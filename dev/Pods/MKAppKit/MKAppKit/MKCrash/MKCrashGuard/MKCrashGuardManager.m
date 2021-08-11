/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKCrashGuardManager.h"
#import "MKException.h"
#import <objc/runtime.h>

@implementation MKCrashGuardManager

#pragma mark - public

/**
 * 启动 App 守护,默认守护所有的类型:MKCrashGuardTypeAll
 */
+ (void)executeAppGuard {
//    [MKCrashGuardManager executeAppGuardWithConfig:MKCrashGuardTypeAll]; 耗时？
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSArray crashGuardExchangeMethod];
        [NSMutableArray crashGuardExchangeMethod];
        [NSDictionary crashGuardExchangeMethod];
        [NSMutableDictionary crashGuardExchangeMethod];
        [NSString crashGuardExchangeMethod];
        [NSMutableString crashGuardExchangeMethod];
        [NSAttributedString crashGuardExchangeMethod];
        [NSMutableAttributedString crashGuardExchangeMethod];

        [NSObject guardUnrecognizedSelectorCrash];
        [NSTimer guardTimerCrash];
        [NSNotificationCenter guardNotificationCrash];
        [NSObject guardKVOCrash];
        [NSObject guardKVCCrash];

        [UINavigationController guardNavigationController];
    });
}

/**
 * 启动 App 守护,自定义守护的类型
 */
+ (void)executeAppGuardWithConfig:(MKCrashGuardType)crashGuardType {
    MKException * exc = [MKException shareException];
    exc.guardCrashType = crashGuardType;
}

/**
 * 注册 crash 信息的回调对象
 */
+ (void)registerCrashHandle:(id<MKExceptionHandle>)crashHandle {
    MKException * exc = [MKException shareException];
    exc.delegate = crashHandle;
}

/**
 * 开启 log
 * @param isLog 是否开启log
 */
+ (void)printLog:(BOOL)isLog {
    MKException * exc = [MKException shareException];
    exc.printLog = isLog;
}


#pragma mark - pri

+ (void)exchangeClassMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector {
    Method method1 = class_getClassMethod(anClass, systemSelector);
    Method method2 = class_getClassMethod(anClass, swizzledSelector);
    method_exchangeImplementations(method1, method2);
}

+ (void)exchangeInstanceMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(anClass, systemSelector);
    Method swizzledMethod = class_getInstanceMethod(anClass, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(anClass,
                    systemSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(anClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

 
@end

