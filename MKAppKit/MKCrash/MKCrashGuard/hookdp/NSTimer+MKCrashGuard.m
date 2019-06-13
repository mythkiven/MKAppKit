/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSTimer+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

@interface MKTimerObject : NSObject

@property(nonatomic,readwrite,assign) NSTimeInterval ti;
@property(nonatomic,readwrite,weak) id target;
@property(nonatomic,readwrite,assign) SEL selector;
@property(nonatomic,readwrite,assign) id userInfo;
@property(nonatomic,readwrite,weak) NSTimer *timer;
@property(nonatomic,readwrite,copy) NSString *targetClassName;
@property(nonatomic,readwrite,copy) NSString *targetMethodName;

@end

@implementation MKTimerObject

- (void)fireTimer {
    if (!self.target) {
        [self.timer invalidate];
        self.timer = nil;
        mkHandleCrashException([NSString stringWithFormat:@"Need invalidate timer from target:%@ method:%@",self.targetClassName,self.targetMethodName]);
        return;
    }
    if ([self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
#pragma clang diagnostic pop
    }
}

@end


#pragma mark -
#pragma mark -

MK_SYNTH_DUMMY_CLASS(NSTimer_MKSELCrashGuard)
@implementation NSTimer (MKCrashGuard)

+ (void)guardTimerCrash {
    mk_swizzleClassMethod([NSTimer class],
                          @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                          @selector(guardScheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
}

+ (NSTimer*)guardScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)repeat {
    if (!repeat) {
        return [self guardScheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:repeat];
    }
    MKTimerObject* timerObject = [MKTimerObject new];
    timerObject.ti = ti;
    timerObject.target = aTarget;
    timerObject.selector = aSelector;
    timerObject.userInfo = userInfo;
    if (aTarget) {
        timerObject.targetClassName = [NSString stringWithCString:object_getClassName(aTarget) encoding:NSASCIIStringEncoding];
    }
    timerObject.targetMethodName = NSStringFromSelector(aSelector);
    NSTimer* timer = [NSTimer guardScheduledTimerWithTimeInterval:ti target:timerObject selector:@selector(fireTimer) userInfo:userInfo repeats:repeat];
    timerObject.timer = timer;
    return timer;
}

@end
