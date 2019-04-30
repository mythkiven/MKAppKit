//
//  MKLoadingManagerView.m
//
//  Created by https://github.com/mythkiven/ on 15/01/18.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "MKLoadingManagerView.h"

#import "MKDradualLoadingView.h"
#import "MKControlLoadingCircleView.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.heigh
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define centerX(v)        v.center.x
#define centerY(v)        v.center.y

#define loadingHelight  160
#define dotOuterRadius  508/4
#define dotInnerRadius (508-16)/4

@interface MKLoadingManagerView ()


// 圆点进度条
@property (nonatomic, strong)   MKControlLoadingCircleView  *dotLoading;
// 外侧纯色转圈
@property (nonatomic,strong)    UIImageView                 *imageLoading;
// 外侧绚丽转圈
@property (nonatomic,strong)    MKDradualLoadingView        *colorLoading;
// 进度文字
@property (nonatomic,strong)    UIButton                    *percentLabel;
// 进度标题
@property (nonatomic,strong)    UILabel                     *titleLabel;

@property (nonatomic,strong)    NSMutableArray              *layerContainer;
@property (nonatomic,strong)    NSMutableDictionary         *timerContainer;
@property (nonatomic,strong)    NSTimer                     *timer;
@property (nonatomic, strong)   CADisplayLink               *link;

@end

@implementation MKLoadingManagerView
{
    CGFloat                 sumPer;
    
}

- (NSMutableDictionary *)timerContainer {
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

- (instancetype)init {
     if (self= [super init]) {
        [self defaultInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
     if (self= [super initWithFrame:frame]) {
        [self defaultInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self= [super initWithCoder:decoder]) {
        [self defaultInit];
    }
    return self;
}

-(void)defaultInit { 
    [self addSubview:self.dotLoading];
    [self addSubview:self.titleLabel];
    [self addSubview:self.percentLabel];
}
-(void)setLoadingType:(MKLoadingManagerType)loadingType {
    _loadingType = loadingType;
    switch (_loadingType) {
        case MKLoadingManagerTypeImage:{
            [self  addSubview:self.imageLoading];
            break;
        }case MKLoadingManagerTypeColor:{
            [self  addSubview:self.colorLoading];
            break;
        }case MKLoadingManagerTypeOther:{
            break;
        }default:
            break;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_imageLoading) {
        _imageLoading.center =  CGPointMake(centerX(self),loadingHelight);
        _imageLoading.bounds =  CGRectMake(0, 0, 281, 281);
    }
    if (_colorLoading) {
        _colorLoading.center =  CGPointMake(centerX(self),loadingHelight);
        _colorLoading.bounds =  CGRectMake(0, 0, 281, 281);
    }
    _dotLoading.bounds = CGRectMake(0,0, 570/2, 570/2);
    _dotLoading.center = CGPointMake(centerX(self), loadingHelight);
    
    _titleLabel.bounds = CGRectMake(0,0, 570/2, 570/2);
    _titleLabel.center = CGPointMake( centerX(self), loadingHelight-20);
    
    _percentLabel.bounds = CGRectMake(0,0, 570/2, 570/2);
    _percentLabel.center = CGPointMake( centerX(self), loadingHelight+20);
}

#pragma mark - 控制
-(void)startAnimationWithPercent:(CGFloat)end duration:(CGFloat)duration {
    if (_imageLoading) {
        _imageLoading.hidden = NO;
        [self startRotating];
    } else if (_colorLoading){
        _colorLoading.hidden = NO;
        _colorLoading.hidden = NO;
        [_colorLoading startAnimation];
    }
    [self startAnimationWithPercent:0 endPercent:end duration:duration];
    
}
-(void)startAnimationWithPercent:(CGFloat)begin endPercent:(CGFloat)end duration:(CGFloat)duration {
    sumPer = end;
    [self cancelTimerWithName:@"timeNEW"];
    __weak typeof(self) weakSelf = self;
    
    if ((end-begin)/duration<=_dotLoading.maxValue/_dotLoading.dotCount) {
        [self scheduledDispatchTimerWithName:@"timeNEW" timeInterval:1 queue:nil repeats:YES action:^{
            [weakSelf settingValue:(CGFloat)(end-begin)/duration];
        }];
    } else if ( (end-begin)/duration>_dotLoading.maxValue/_dotLoading.dotCount) {
        CGFloat time = (end-begin) / (_dotLoading.maxValue/_dotLoading.dotCount);
        [self scheduledDispatchTimerWithName:@"timeNEW" timeInterval:duration/time queue:nil repeats:YES action:^{
            [weakSelf settingValue:(_dotLoading.maxValue/_dotLoading.dotCount)];
        }];
    }else {
    }
    
//    CGFloat timee =(CGFloat) (end-begin) / (_progress.maxValue/_progress.dotCount);
//    
//    [self scheduledDispatchTimerWithName:@"timeNEW" timeInterval:duration/timee queue:nil repeats:YES action:^{
//        
//        totalTime +=duration/timee;
//        time +=duration/timee;
//        [weakSelf settingValue:(_progress.maxValue/_progress.dotCount)];
//        
//        CGFloat value = _progress.currentValue;
//        if (value>= sumPer) {
//            if (completeblock) completeblock();
//            
//            
//            return;
//        }
//        
//    }];
}
-(void)stopAnimation {
    if (_imageLoading) {
        [self stopRotating];
        _imageLoading.hidden =YES;
    } else if (_colorLoading){
        [_colorLoading stopAnimation];
        _colorLoading.hidden =YES;
    }
    _dotLoading.currentValue =0;
    [_percentLabel setTitle:@"" forState:UIControlStateNormal];
    [_percentLabel setImage:nil forState:UIControlStateNormal];
    [self cancelTimerWithName:@"timeNEW"];
}




#pragma mark 设置数值
-(void)settingValue:(CGFloat)sum {
    CGFloat value = _dotLoading.currentValue;
    if (value>= sumPer) {
        [self cancelTimerWithName:@"timeNEW"];
        return;
    }
    _dotLoading.currentValue = value + sum; 
    if (value>=99) {
        [_percentLabel setTitle:@"" forState:UIControlStateNormal];
        [_percentLabel setImage:[self imagesFromBundleWithName:@"mkcla-imageHook"] forState:UIControlStateNormal];
    }else{
        [_percentLabel setTitle:[NSString stringWithFormat:@"%ld%%",(long)_dotLoading.currentValue] forState:UIControlStateNormal];
    }
}

#pragma mark - 定时器
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action {
    if (nil == timerName)
        return;
    if (nil == queue)
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            action();
        });
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
}
- (void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}


#pragma mark - 设置旋转的图片
- (void)startRotating {
    if (self.link){
        return;
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotating)];
//    link.frameInterval =1;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

- (void)stopRotating  {
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
}
- (void)rotating {
    self.imageLoading.transform = CGAffineTransformRotate(self.imageLoading.transform, (M_PI/180)/0.85);
}
                      
#pragma mark -
-(UIButton*)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_percentLabel setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        _percentLabel.titleLabel.text =  @"0%";
        _percentLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel. titleLabel.font = [UIFont systemFontOfSize:20 weight:0.4];
    }
    return _percentLabel;
}
-(UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.text =  @"github.com/mythkiven";
        _titleLabel.textColor =[UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:0.4];
    }
    return _titleLabel;
}
-(MKControlLoadingCircleView*)dotLoading {
  if (!_dotLoading) {
      _dotLoading = [[MKControlLoadingCircleView alloc] init];
      _dotLoading.backgroundColor = [UIColor clearColor];
      
      _dotLoading.outerRadius = dotOuterRadius;
      _dotLoading.innerRadius = dotInnerRadius;
      _dotLoading.clockwise = YES;
      _dotLoading.beginAngle = 360;
      
      _dotLoading.gapAngle = 2;
      _dotLoading.dotCount = 100;
      
      _dotLoading.trackColor = RGBA(204, 204, 204, 0.3);
      _dotLoading.progressColor = RGB(85, 255, 0);
      _dotLoading.backgroundColor = [UIColor clearColor];
      
      _dotLoading.minValue = 0;
      _dotLoading.maxValue = 100;
      _dotLoading.currentValue = 0;
  }
  return _dotLoading;
}
-(UIImageView*)imageLoading {
  if (!_imageLoading) {
      _imageLoading= [[UIImageView alloc] initWithImage:[self imagesFromBundleWithName:@"mkcla-imageLoading"]];
      _imageLoading.clipsToBounds = YES;
      [self addSubview:_imageLoading];
  }
    return _imageLoading;
}
-(MKDradualLoadingView*)colorLoading {
    if (!_colorLoading) {
        _colorLoading = [[MKDradualLoadingView alloc] init];
        _colorLoading.backgroundColor = [UIColor clearColor];
        _colorLoading.lineColor = [UIColor cyanColor];
        _colorLoading.lineWidth = 5;
        _colorLoading.hidden = YES;
    }
    return _colorLoading;
}
- (UIImage *)imagesFromBundleWithName:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[self bundle] compatibleWithTraitCollection:nil];
}
- (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    if ( nil == bundle ) {
        NSString* bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"MKCLAResource.bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bundle;
}
@end
