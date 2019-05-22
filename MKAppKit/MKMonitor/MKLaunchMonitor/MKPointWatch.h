
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/13.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 * 打点的时间误差在 0.0003s以内
 */


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLStopwatchSplitType) {
    MKPointWatchTypeSection = 1, // 分段记录
    MKPointWatchTypeContinuous  // 连续记录
};

NS_ASSUME_NONNULL_BEGIN

@interface MKPointWatch : NSObject

+ (instancetype)pointWatch;

/**
 * 记录的所有点
 */
@property (nonatomic,copy, readonly) NSArray<NSDictionary<NSString *, NSNumber *> *> *points;
/**
 * 当次打点的时长
 */
@property (nonatomic,assign, readonly) NSTimeInterval lastWatchInterval;
/**
 * 格式化后的打点字符串
 */
@property (nonatomic,copy, readonly) NSString* printedPoints;

/**
 *  简单计时开始
 */
+ (void)timeBegin;
/**
 * 简单计时结束
 */
+ (CFTimeInterval)timeEnd;
/**
 * 简单计时结束
 * @param type 记录的类型.
 */
+ (CFTimeInterval)timeEndWithType:(BLStopwatchSplitType)type;

/**
 * 开始打点
 */
- (void)startWatching;
/**
 * 结束打点
 */
- (void)stopWatching;
/**
 * 结束打点,并alert打点结果
 */
- (void)stopWatchingAndAlertResult;
/**
 * 重置打点
 */
- (void)resetWatching;
/**
 * 打点(使用缺省值：记录中间值)
 * @param description 打点描述
 */
- (void)pointWithDescription:(NSString * _Nullable)description;
/**
 * 打点(自定义打点类型)
 * @param type 记录的类型.
 * @param description 描述信息.
 */
- (void)pointWithType:(BLStopwatchSplitType)type description:(NSString * _Nullable)description;

@end

NS_ASSUME_NONNULL_END
