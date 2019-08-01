/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>

@interface NSTimer (MKCategory)

+ (NSTimer *)mk_timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo handler:(void(^)(void))handler;
+ (NSTimer *)mk_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo handler:(void(^)(void))handler;

@end
