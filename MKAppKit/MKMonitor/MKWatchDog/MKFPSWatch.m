/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKFPSWatch.h"
#import <AudioToolbox/AudioToolbox.h>


@interface MKFPSWatch ()

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

@implementation MKFPSWatch

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
    NSInteger droppedFrameCount = self.droppedFrameCountInLastSecond;
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
    if(self.recordRender){
        self.recordRender(@{@"droppedFrameCount":@(droppedFrameCount),@"drawnFrameCount":@(drawnFrameCount)});
    }
}

- (CFTimeInterval)hardwareFrameDuration {
    return 1.0 / self.hardwareFramesPerSecond;
}

- (void)displayLinkWillDraw:(CADisplayLink *)displayLink {
    CFTimeInterval currentFrameTime = displayLink.timestamp;
    CFTimeInterval frameDuration = currentFrameTime - [self lastFrameTime];
    if (1.5 < frameDuration / [self hardwareFrameDuration]) {
        AudioServicesPlaySystemSound(self.tickSoundID);
    }
    [self recordFrameTime:currentFrameTime];
    [self updateMeterLabel];
}

#pragma mark -

- (void)start {
    NSURL *tickSoundURL = [[NSBundle bundleForClass:MKFPSWatch.class] URLForResource:@"MKFPSWatchTick" withExtension:@"aiff"];
    SystemSoundID tickSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) tickSoundURL, &tickSoundID);
    self.tickSoundID = tickSoundID;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkWillDraw:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self clearLastSecondOfFrameTimes];
}

- (void)stop {
    [self.displayLink invalidate];
    self.displayLink = nil;
    AudioServicesDisposeSystemSoundID(self.tickSoundID);
    self.tickSoundID = 0;
}

- (void)setRunning:(BOOL)running {
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

- (void)applicationDidBecomeActive {
    self.running = self.enabled;
}

- (void)applicationWillResignActive {
    self.running = NO;
}

#pragma mark -

- (void)enable {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.windowLevel = self.windowLevel;
    self.window.userInteractionEnabled = NO; 
    CGFloat const kMeterWidth = 145.0;
    CGFloat xOrigin = 0.0;
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    switch (self.position) {
        case MKFPSWatchPositionLeft:
            xOrigin = 0.0;
            autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
            break;
        case MKFPSWatchPositionMiddle:
            xOrigin = (CGRectGetWidth(self.window.bounds) - kMeterWidth) / 2.0;
            autoresizingMask |= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            break;
        case MKFPSWatchPositionRight:
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
- (void)disable {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.running = NO;
    self.meterLabel = nil;
    self.window = nil;
}

#pragma mark - Public interface

+ (instancetype)sharedFPSCounter {
    static MKFPSWatch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MKFPSWatch alloc] init];
    });
    return instance;
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        if (enabled) {
            [self enable];
        } else {
            [self disable];
        }
        
        _enabled = enabled;
    }
}

- (void)setShowLabel:(BOOL)showLabel{
    _showLabel = showLabel;
    self.meterLabel.hidden = !_showLabel;
}

- (void)setWindowLevel:(UIWindowLevel)windowLevel {
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

- (NSInteger)drawnFrameCountInLastSecond {
    if (!self.running || self.frameNumber < self.hardwareFramesPerSecond) {
        return -1;
    }
    return self.hardwareFramesPerSecond - self.droppedFrameCountInLastSecond;
}

#pragma mark - Init/dealloc

- (instancetype)init {
    self = [super init];
    if (self) {
        _windowLevel = UIWindowLevelAlert+1;
        _position = MKFPSWatchPositionRight;
        _meterPerfectColor = [MKFPSWatch colorWithHex:0x999999 alpha:1.0];
        _meterGoodColor = [MKFPSWatch colorWithHex:0x66a300 alpha:1.0];
        _meterBadColor = [MKFPSWatch colorWithHex:0xff7f0d alpha:1.0];
        if (@available(iOS 10.3, *)) {
            _hardwareFramesPerSecond = [UIScreen mainScreen].maximumFramesPerSecond;
        } else {
            _hardwareFramesPerSecond = 60;
        }
        _recentFrameTimes = malloc(sizeof(*_recentFrameTimes) * _hardwareFramesPerSecond);
    }
    return self;
}

- (void)dealloc {
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

@end

