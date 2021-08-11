/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSObject+MKCrashGuard.h"
#import "MKCrashGuardManager.h"
#import "MKCrashGuardConst.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"


MK_SYNTH_DUMMY_CLASS(NSObject_MKCrashGuard)
@implementation NSObject (MKCrashGuard)

#pragma mark - pub
/**
 防护 Unrecognized
 @param isGuardUnrecognized 是否防护 Unrecognized
 */
+ (void)mk_guardSelector:(BOOL)isGuardUnrecognized {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ 
        //unrecognized selector sent to instance
        if (isGuardUnrecognized) {
            [MKCrashGuardManager exchangeInstanceMethod:[self class] systemSelector:@selector(methodSignatureForSelector:) swizzledSelector:@selector(crashGuardMethodSignatureForSelector:)];
            [MKCrashGuardManager exchangeInstanceMethod:[self class] systemSelector:@selector(forwardInvocation:) swizzledSelector:@selector(crashGuardForwardInvocation:)];
        }
    });
}

static NSMutableArray *mkUnrecognizedSelectorClassPrefixs;
/**
 防护 Unrecognized
 @param classPrefixs 需要防护的类名或类名前缀
 */
+ (void)mk_guardSelectorWithClassPrefixs:(NSArray<NSString *> *)classPrefixs{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ 
        mkUnrecognizedSelectorClassPrefixs = [NSMutableArray array];
        for (NSString *classNamePrefix in classPrefixs) {
           if (![classNamePrefix hasPrefix:@"UI"] &&![classNamePrefix isEqualToString:@"NS"] && ![classNamePrefix isEqualToString:NSStringFromClass([NSObject class])]) {
                [mkUnrecognizedSelectorClassPrefixs addObject:classNamePrefix];
            } else {
                MKCrashGuardLog(@"\n ==================================== \n[MKCrashGuard mk_guardSelectorWithClassPrefixs:];\n 忽略UI开头的类、NSObject\n  ====================================  \n");
            }
        }
    });
}

#pragma mark - pri
- (NSMethodSignature *)crashGuardMethodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *ms = [self crashGuardMethodSignatureForSelector:aSelector];
    BOOL flag = NO;
    if (flag == NO) {
        NSString *selfClass = NSStringFromClass([self class]);
        for (NSString *classStrPrefix in mkUnrecognizedSelectorClassPrefixs) {
            if ([selfClass hasPrefix:classStrPrefix]  || [self isKindOfClass:NSClassFromString(classStrPrefix)]) {
                ms = [MKCrashGuardConst instanceMethodSignatureForSelector:@selector(mkProxyMethod)];
            }
        }
    }
    return ms;
} 
- (void)crashGuardForwardInvocation:(NSInvocation *)anInvocation {
    @try {
        [self crashGuardForwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        mkHandleCrashException(exception);
    } @finally {
    }
}


@end
