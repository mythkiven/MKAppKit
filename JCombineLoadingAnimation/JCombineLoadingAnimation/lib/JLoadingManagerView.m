//
//  JLoadingManagerView.m
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/18.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "JLoadingManagerView.h"

#import "JDradualLoadingView.h"
#import "JControlLoadingCircleView.h"


@interface JLoadingManagerView ()


@property (nonatomic, strong)   JControlLoadingCircleView   *progress;
@property (nonatomic,strong)    NSMutableArray              *layerContainer;
@property (nonatomic,strong)    NSMutableDictionary         *timerContainer;


@property (nonatomic,strong)    UILabel *progressLabel;
@property (nonatomic,strong)    UILabel *titleLabel;
@property (nonatomic,strong)    NSTimer *timer;

@end


@implementation JLoadingManagerView
{
    JDradualLoadingView   * loading;
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

-(void)defaultInit{
    
    //外层动画：
    loading = [[JDradualLoadingView alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
    loading.center = CGPointMake(self.center.x, (self.center.y));
    loading.backgroundColor = [UIColor clearColor];
    loading.lineColor = [UIColor cyanColor];
    loading.lineWidth = 10;
    
    loading.hidden = YES;
    
    //文字
    self.progressLabel = [[UILabel alloc] initWithFrame: CGRectMake((self.bounds.size.width - 100)/2, (self.bounds.size.height + 20)/2, 100, 30)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 160)/2, (self.bounds.size.height - 100)/2, 160, 30)];
    
    [self.progressLabel setTextColor:[UIColor whiteColor]];
    self.progressLabel.text =  @"0%";
    self.progressLabel.textColor =[UIColor blackColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:20 weight:0.4];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.text =  @"github.com/mythkiven";
    self.titleLabel.textColor =[UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12 weight:0.4];
    
    
    
    _progress = [[JControlLoadingCircleView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
    _progress.center =  CGPointMake(self.center.x, (self.center.y));
    _progress.backgroundColor = [UIColor clearColor];
    
    _progress.outerRadius = 110;
    _progress.innerRadius = 95;
    _progress.clockwise = YES;
    _progress.beginAngle = 360;
    
    _progress.gapAngle = 3;
    _progress.dotCount = 50;
    
    _progress.progressColor = [UIColor greenColor];
    _progress.trackColor    = [UIColor clearColor];
    _progress.backgroundColor = [UIColor clearColor];
    
    _progress.minValue = 0;
    _progress.maxValue = 100;
    _progress.currentValue = 0;
    
    [self  addSubview:loading];
    
    [self addSubview:_progress];
    [self addSubview:self.progressLabel];
    [self addSubview:self.titleLabel];
    
    
}




# pragma mark 控制
-(void)startAnimationWithPercent:(CGFloat)end duration:(CGFloat)duration{
    loading.hidden = NO;
    [loading startAnimation];
    [self startAnimationWithPercent:0 endPercent:end duration:duration];
    
}

-(void)startAnimationWithPercent:(CGFloat)begin endPercent:(CGFloat)end duration:(CGFloat)duration {
    
    sumPer = end;
    [self cancelTimerWithName:@"timeNEW"];
    __weak typeof(self) weakSelf = self;
    
    if ((end-begin)/duration<=_progress.maxValue/_progress.dotCount) {
        [self scheduledDispatchTimerWithName:@"timeNEW" timeInterval:1 queue:nil repeats:YES action:^{
            
            [weakSelf settingValue:(CGFloat)(end-begin)/duration];
        }];
        
    } else if ( (end-begin)/duration>_progress.maxValue/_progress.dotCount) {
        CGFloat time = (end-begin) / (_progress.maxValue/_progress.dotCount);
        
        [self scheduledDispatchTimerWithName:@"timeNEW" timeInterval:duration/time queue:nil repeats:YES action:^{
            
            [weakSelf settingValue:(_progress.maxValue/_progress.dotCount)];
        }];
        
    }else {
        
    }
}
-(void)endAnimation{
    [loading stopAnimation];
    [loading removeFromSuperview];
    [self removeFromSuperview];
}




# pragma mark 设置数值


-(void)settingValue:(CGFloat)sum{
    CGFloat value = _progress.currentValue;
    if (value>= sumPer) {
        [self cancelTimerWithName:@"timeNEW"];
        return;
    }
    _progress.currentValue = value + sum;
    _progressLabel.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)_progress.currentValue];
}

# pragma mark 定时器
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
{
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
# pragma mark 暂停
- (void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    
}






@end
