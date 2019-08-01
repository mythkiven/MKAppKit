/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSTimer+MKCategory.h"

@implementation NSTimer (MKCategory)

+ (NSTimer *)mk_timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo handler:(void(^)(void))handler
{
    return [self timerWithTimeInterval:ti target:self selector:@selector(_timerHandler:) userInfo:[handler copy] repeats:yesOrNo];
}

+ (NSTimer *)mk_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo handler:(void(^)(void))handler
{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(_timerHandler:) userInfo:[handler copy] repeats:yesOrNo];
}

+ (void)_timerHandler:(NSTimer *)inTimer;
{
    if (inTimer.userInfo)
    {
        void(^handler)(void) = [inTimer userInfo];
        handler();
    }
}

@end
