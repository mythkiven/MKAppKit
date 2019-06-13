/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSObject+MKNotificationCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>


MK_SYNTH_DUMMY_CLASS(NSObject_MKNotificationCrashGuard)
@implementation  NSObject (MKNotificationCrashGuard)

+ (void)guardNotificationCrash {
    // 添加通知后，没有移除导致Crash的问题 在 9.0 以后没有出现了。
    if(@available(iOS 9.0, *))
        return;
    [self mk_swizzleInstanceMethod:@selector(addObserver:selector:name:object:) withSwizzledBlock:^id(MKSwizzleObject *swizzleInfo) {
        return ^(__unsafe_unretained id self,id observer,SEL aSelector,NSString* aName,id anObject){
            [self guardAddObserver:observer selector:aSelector name:aName object:anObject swizzleInfo:swizzleInfo];
//            mk_swizzleInstanceMethod(self, NSSelectorFromString(@"dealloc"), NSSelectorFromString(@"guardDealloc"));
        };
    }];
}

- (void)guardAddObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject swizzleInfo:(MKSwizzleObject*)swizzleInfo {
    if (!observer) {
        return;
    }
    if ([observer isKindOfClass:NSObject.class]) {
        __unsafe_unretained typeof(observer) unsafeObject = observer;
        [observer mk_runAtDealloc:^{
            [[NSNotificationCenter defaultCenter] removeObserver:unsafeObject];
        }];
    }
//    [observer setIsNSNotification:YES]; 
    void(*originIMP)(__unsafe_unretained id,SEL,id,SEL,NSString*,id);
    originIMP = (__typeof(originIMP))[swizzleInfo getOriginalImplementation];
    if (originIMP != NULL) {
        originIMP(self,swizzleInfo.selector,observer,aSelector,aName,anObject);
    }
}

//static const char *isMKNSNotification = "isMKNSNotification";
//
//- (void)setIsNSNotification:(BOOL)yesOrNo {
//    objc_setAssociatedObject(self, isMKNSNotification, @(yesOrNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (BOOL)isMKNSNotification {
//    NSNumber *number = objc_getAssociatedObject(self, isMKNSNotification);;
//    return  [number boolValue];
//}
//- (void)guardDealloc {
//    if ([self isMKNSNotification]) {
//        mkHandleCrashException([NSString stringWithFormat:@"[NSObject delloc]  %@ is dealloc，but NSNotificationCenter Also exsit",self]);
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
//    [self guardDealloc];
//}

@end
