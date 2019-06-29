//
//  MKRenderCounter.m
//  MKApp
//
//  Created by apple on 2019/6/25.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import "MKRenderCounter.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MKRenderCounter ()

@property (nonatomic, readwrite, assign, getter = isRunning) BOOL running;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UILabel *meterLabel;
@property (nonatomic, strong) UIColor *meterPerfectColor;
@property (nonatomic, strong) UIColor *meterGoodColor;
@property (nonatomic, strong) UIColor *meterBadColor;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) SystemSoundID tickSoundID;
@property (nonatomic, assign) NSInteger frameNumber;
@property (nonatomic, assign) NSInteger hardwareFramesPerSecond;
@property (nonatomic, assign) CFTimeInterval *recentFrameTimes; // malloc: CFTimeInterval[hardwareFramesPerSecond]

@end

@implementation MKRenderCounter

#pragma mark - Helpers

+ (UIColor *)colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha {
    CGFloat red   = (CGFloat) ((hex & 0xff0000) >> 16) / 255.0f;
    CGFloat green = (CGFloat) ((hex & 0x00ff00) >> 8)  / 255.0f;
    CGFloat blue  = (CGFloat)  (hex & 0x0000ff)        / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CFTimeInterval)lastFrameTime {
    return _recentFrameTimes[self.frameNumber % self.hardwareFramesPerSecond];
}

// 通过一个数组（60个元素），来记录屏幕每次刷新时的时间（60次刷新的时间）
- (void)recordFrameTime:(CFTimeInterval)frameTime {
    ++self.frameNumber;
    _recentFrameTimes[self.frameNumber % self.hardwareFramesPerSecond] = frameTime;
}

- (void)clearLastSecondOfFrameTimes {
    CFTimeInterval initialFrameTime = CACurrentMediaTime();
    for (NSInteger i = 0; i < self.hardwareFramesPerSecond; ++i) {
        _recentFrameTimes[i] = initialFrameTime;
    }
    self.frameNumber = 0;
}

- (void)updateMeterLabel {
    // 一秒钟屏幕刷新时的丢帧数
    NSInteger droppedFrameCount = self.droppedFrameCountInLastSecond;
    // 一秒钟屏幕刷新时的显示帧数
    NSInteger drawnFrameCount = self.drawnFrameCountInLastSecond;
    
    NSString *droppedString;
    NSString *drawnString;
    
    if (droppedFrameCount <= 0) {
        self.meterLabel.backgroundColor = self.meterPerfectColor;
        
        droppedString = @"--";
    } else {
        if (droppedFrameCount <= 2) {
            self.meterLabel.backgroundColor = self.meterGoodColor;
        } else {
            self.meterLabel.backgroundColor = self.meterBadColor;
        }
        
        droppedString = [NSString stringWithFormat:@"lost:%ld", (long) droppedFrameCount];
    }
    
    if (drawnFrameCount == -1) {
        drawnString = @"--";
    } else {
        drawnString = [NSString stringWithFormat:@"displayed:%ld", (long) drawnFrameCount];
    }
    
    self.meterLabel.text = [NSString stringWithFormat:@"fps:%@ %@", droppedString, drawnString];
}

- (CFTimeInterval)hardwareFrameDuration {
    return 1.0 / self.hardwareFramesPerSecond;
}

- (void)displayLinkWillDraw:(CADisplayLink *)displayLink {
    // 当前屏幕刷新回调的时间
    CFTimeInterval currentFrameTime = displayLink.timestamp;
    // 这次屏幕刷新和上一次屏幕刷新的时间间隔
    CFTimeInterval frameDuration = currentFrameTime - [self lastFrameTime];
    // 如果界面不卡顿，那么屏幕刷新频率应该是1秒钟60帧，那么帧间间隔时间应该是1/60秒，如果当前刷新和上一次屏幕刷新的时间间隔，超过这个时间间隔，那么就属于卡顿
    // 则系统响一下，这里设定，屏幕刷新如果是1秒钟少于40帧（60/1.5）则响一下。
    if (1.5 < frameDuration / [self hardwareFrameDuration]) {
        AudioServicesPlaySystemSound(self.tickSoundID);
    }
    // 记录每次屏幕刷新时的时间（60次）
    [self recordFrameTime:currentFrameTime];
    // 显示帧率和丢帧数
    [self updateMeterLabel];
}

#pragma mark -

- (void)start {
    NSURL *tickSoundURL = [[NSBundle bundleForClass:MKRenderCounter.class] URLForResource:@"MKRenderCounterTick" withExtension:@"aiff"];
    SystemSoundID tickSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) tickSoundURL, &tickSoundID);
    self.tickSoundID = tickSoundID;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkWillDraw:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self clearLastSecondOfFrameTimes];
}

- (void)stop
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    AudioServicesDisposeSystemSoundID(self.tickSoundID);
    self.tickSoundID = 0;
}

- (void)setRunning:(BOOL)running
{
    if (_running != running) {
        if (running) {
            [self start];
        } else {
            [self stop];
        }
        
        _running = running;
    }
}

#pragma mark -

- (void)applicationDidBecomeActive
{
    self.running = self.enabled;
}

- (void)applicationWillResignActive
{
    self.running = NO;
}

#pragma mark -

- (void)enable
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.windowLevel = self.windowLevel;
    self.window.userInteractionEnabled = NO;
    
    CGFloat const kMeterWidth = 145.0;
    CGFloat xOrigin = 0.0;
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    switch (self.position) {
        case MKRenderCounterPositionLeft:
            xOrigin = 0.0;
            autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
            break;
        case MKRenderCounterPositionMiddle:
            xOrigin = (CGRectGetWidth(self.window.bounds) - kMeterWidth) / 2.0;
            autoresizingMask |= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            break;
        case MKRenderCounterPositionRight:
            xOrigin = (CGRectGetWidth(self.window.bounds) - kMeterWidth);
            autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
            break;
    }
    
    CGFloat meterHeight = fmax(20.0, fmin(30.0, [UIApplication sharedApplication].statusBarFrame.size.height));
    self.meterLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0.0,
                                                                kMeterWidth, meterHeight)];
    self.meterLabel.autoresizingMask = autoresizingMask;
    self.meterLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.meterLabel.backgroundColor = [UIColor grayColor];
    self.meterLabel.textColor = [UIColor whiteColor];
    self.meterLabel.textAlignment = NSTextAlignmentCenter;
    [self.window.rootViewController.view addSubview:self.meterLabel];
    
    self.window.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        self.running = YES;
    }
}

- (void)disable
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.running = NO;
    
    self.meterLabel = nil;
    self.window = nil;
}

#pragma mark - Init/dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        _windowLevel = UIWindowLevelStatusBar + 10.0;
        _position = MKRenderCounterPositionRight;
        
        _meterPerfectColor = [MKRenderCounter colorWithHex:0x999999 alpha:1.0];
        _meterGoodColor = [MKRenderCounter colorWithHex:0x66a300 alpha:1.0];
        _meterBadColor = [MKRenderCounter colorWithHex:0xff7f0d alpha:1.0];
        
        if (@available(iOS 10.3, *)) {
            _hardwareFramesPerSecond = [UIScreen mainScreen].maximumFramesPerSecond;
        } else {
            _hardwareFramesPerSecond = 60;
        }
        
        _recentFrameTimes = malloc(sizeof(*_recentFrameTimes) * _hardwareFramesPerSecond);
    }
    return self;
}

- (void)dealloc
{
    [_displayLink invalidate];
    
    if (_tickSoundID) {
        AudioServicesDisposeSystemSoundID(_tickSoundID);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_recentFrameTimes) {
        free(_recentFrameTimes);
        _recentFrameTimes = nil;
    }
}

#pragma mark - Public interface

+ (instancetype)sharedGeigerCounter
{
    static MKRenderCounter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MKRenderCounter alloc] init];
    });
    return instance;
}

- (void)setEnabled:(BOOL)enabled
{
    if (_enabled != enabled) {
        if (enabled) {
            [self enable];
        } else {
            [self disable];
        }
        
        _enabled = enabled;
    }
}

- (void)setWindowLevel:(UIWindowLevel)windowLevel
{
    _windowLevel = windowLevel;
    self.window.windowLevel = windowLevel;
}

// 获取上一秒丢失的帧数
- (NSInteger)droppedFrameCountInLastSecond {
    NSInteger droppedFrameCount = 0;
    CFTimeInterval lastFrameTime = CACurrentMediaTime() - [self hardwareFrameDuration];
    for (NSInteger i = 0; i < self.hardwareFramesPerSecond; ++i) {
        if (1.0 <= lastFrameTime - _recentFrameTimes[i]) {
            ++droppedFrameCount;
        }
    }
    
    return droppedFrameCount;
}

- (NSInteger)drawnFrameCountInLastSecond
{
    if (!self.running || self.frameNumber < self.hardwareFramesPerSecond) {
        return -1;
    }
    
    return self.hardwareFramesPerSecond - self.droppedFrameCountInLastSecond;
}

@end

