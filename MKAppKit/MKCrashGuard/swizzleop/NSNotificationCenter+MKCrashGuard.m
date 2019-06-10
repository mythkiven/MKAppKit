/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSNotificationCenter+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>







MK_SYNTH_DUMMY_CLASS(NSNotificationCenter_MKCrashGuard)
@implementation NSNotificationCenter (MKCrashGuard)

+ (void)guardNotificationCrash {
    [self mk_swizzleInstanceMethod:@selector(addObserver:selector:name:object:) withSwizzledBlock:^id(MKSwizzleObject *swizzleInfo) {
        return ^(__unsafe_unretained id self,id observer,SEL aSelector,NSString* aName,id anObject){
            [self guardAddObserver:observer selector:aSelector name:aName object:anObject swizzleInfo:swizzleInfo];
        };
    }];
}

- (void)guardAddObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject swizzleInfo:(MKSwizzleObject*)swizzleInfo {
    if (!observer) {
        return;
    }
    if ([observer isKindOfClass:NSObject.class]) {
        __unsafe_unretained typeof(observer) unsafeObject = observer;
        [observer mk_deallocBlock:^{
            [[NSNotificationCenter defaultCenter] removeObserver:unsafeObject];
        }];
    }
    void(*originIMP)(__unsafe_unretained id,SEL,id,SEL,NSString*,id);
    originIMP = (__typeof(originIMP))[swizzleInfo getOriginalImplementation];
    if (originIMP != NULL) {
        originIMP(self,swizzleInfo.selector,observer,aSelector,aName,anObject);
    }
}


@end
