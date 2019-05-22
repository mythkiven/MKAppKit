
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/13.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 * 打点的时间误差在 0.0003s以内
 */


#import "MKPointWatch.h"
#import "pthread.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKPointWatchState) {
    MKPointWatchStateInitial = 0,
    MKPointWatchStateRuning,
    MKPointWatchStateStop,
};

@interface MKPointWatch ()

@property (nonatomic) CFTimeInterval startTimeInterval;
@property (nonatomic) CFTimeInterval tempTimeInterval;
@property (nonatomic) CFTimeInterval stopTimeInterval;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, NSNumber *> *> *mutablePoints;
@property (nonatomic) MKPointWatchState state;
@property (nonatomic) pthread_mutex_t lock;

@end

@implementation MKPointWatch

static MKPointWatch *_watch;
+ (instancetype)pointWatch {
    if(_watch){
        return _watch;
    }else{
        _watch = [[MKPointWatch alloc]init];
    }
    return _watch;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _watch = [super allocWithZone:zone];
    });
    return _watch;
}
- (instancetype)init {
    if(self = [super init]){
        _mutablePoints = [NSMutableArray array];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}
- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}


CFAbsoluteTime MKPointWatchBeginTime;
CFAbsoluteTime MKPointWatchBreakTime;
#pragma mark 计时
+ (void)timeBegin { 
    MKPointWatchBeginTime = CACurrentMediaTime();
    MKPointWatchBreakTime = MKPointWatchBeginTime;
}
+ (CFTimeInterval)timeEnd {
    return [self timeEndWithType:MKPointWatchTypeContinuous];
}
+ (CFTimeInterval)timeEndWithType:(BLStopwatchSplitType)type{
    if(type == MKPointWatchTypeSection){
        CFTimeInterval timeDiff = (CACurrentMediaTime() - MKPointWatchBreakTime);
        MKPointWatchBreakTime = CACurrentMediaTime();
        return timeDiff;
    }
    CFTimeInterval timeDiff = (CACurrentMediaTime() - MKPointWatchBeginTime);
    return timeDiff;
}

#pragma mark 打点
- (NSString *)printedPoints{
    NSMutableString *output = [[NSMutableString alloc] init];
    pthread_mutex_lock(&_lock);
    [self.mutablePoints enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSNumber *> *obj, NSUInteger idx, BOOL *stop) {
        [output appendFormat:@"%@: %.6f\n", obj.allKeys.firstObject, obj.allValues.firstObject.doubleValue];
    }];
    pthread_mutex_unlock(&_lock);
    return [output copy];
}
- (NSArray *)points {
    pthread_mutex_lock(&_lock);
    NSMutableArray<NSDictionary<NSString *, NSNumber *> *> *array = [self.mutablePoints copy];
    pthread_mutex_unlock(&_lock);
    return array;
}
- (NSTimeInterval)lastWatchInterval {
    switch (self.state) {
        case MKPointWatchStateInitial:
            return 0;
        case MKPointWatchStateRuning:
            return CACurrentMediaTime() - self.startTimeInterval;
        case MKPointWatchStateStop:
            return self.stopTimeInterval - self.startTimeInterval;
    }
}

- (void)startWatching {
    if(self.state != MKPointWatchStateInitial){
        [[MKPointWatch pointWatch] resetWatching];
    }
    self.state = MKPointWatchStateRuning;
    self.startTimeInterval = CACurrentMediaTime();
    self.tempTimeInterval = self.startTimeInterval;
}
- (void)stopWatching {
    if (self.state != MKPointWatchStateRuning) {
        return;
    }
    self.state = MKPointWatchStateStop;
    self.stopTimeInterval = CACurrentMediaTime();
}
- (void)resetWatching {
    self.state = MKPointWatchStateInitial;
    pthread_mutex_lock(&_lock);
    [self.mutablePoints removeAllObjects];
    pthread_mutex_unlock(&_lock);
    self.startTimeInterval = 0;
    self.stopTimeInterval = 0;
    self.tempTimeInterval = 0;
}
- (void)pointWithDescription:(NSString * _Nullable)description {
    [self pointWithType:MKPointWatchTypeSection description:description];
}
- (void)pointWithType:(BLStopwatchSplitType)type description:(NSString * _Nullable)description {
    if (self.state != MKPointWatchStateRuning) {
        return;
    }
    NSTimeInterval tempTimeInterval = CACurrentMediaTime();
    CFTimeInterval splitTimeInterval = type == MKPointWatchTypeSection?tempTimeInterval-self.tempTimeInterval:tempTimeInterval-self.startTimeInterval;
    NSInteger count = self.mutablePoints.count + 1;
    NSMutableString *finalDescription = [NSMutableString stringWithFormat:@"#%@", @(count)];
    if (description) {
        [finalDescription appendFormat:@" %@", description];
    }
    pthread_mutex_lock(&_lock);
    [self.mutablePoints addObject:@{finalDescription : @(splitTimeInterval)}];
    pthread_mutex_unlock(&_lock);
    self.tempTimeInterval = tempTimeInterval;
}
- (void)stopWatchingAndAlertResult {
    [[MKPointWatch pointWatch] stopWatching];
    [[[UIAlertView alloc] initWithTitle:@"MKPointWatch 打点结果(s)"
                                message:self.printedPoints
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show]; 
}

@end

NS_ASSUME_NONNULL_END
