/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "NSMutableArray+MKCrashGuard.h"
#import "NSAttributedString+MKCrashGuard.h"
#import "NSString+MKCrashGuard.h"
#import "NSMutableString+MKCrashGuard.h"
#import "NSMutableAttributedString+MKCrashGuard.h"
#import "NSObject+MKCrashGuard.h"
#import "NSArray+MKCrashGuard.h"
#import "NSDictionary+MKCrashGuard.h"
#import "NSMutableDictionary+MKCrashGuard.h"
#import "MKCrashGuardConst.h"

NS_ASSUME_NONNULL_BEGIN




@interface MKCrashGuardManager : NSObject 
/**
 在 application: didFinishLaunchingWithOptions: 中调用，启动 App 守护
 */
+ (void)executeAppGuard;
/**
 启用 "unrecognized selector sent to instance" crash 防护，请传入需要防护的 类名或类名前缀
 @param classPrefixs 防护的类名或类名前缀
 */
+ (void)guardSelectorWithClassPrefixs:(NSArray<NSString *> *)classPrefixs;



//  DEBUG 模式下，crash 信息会打印出来，同时发送一个名为 @"MKCrashGuardErrorNotification" 的通知，用户可监听通知并进行上报处理等。
+ (void)printErrorInfo:(NSException *)exception describe:(NSString *)description;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));
+ (void)exchangeClassMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));
+ (void)exchangeInstanceMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));

@end
NS_ASSUME_NONNULL_END




