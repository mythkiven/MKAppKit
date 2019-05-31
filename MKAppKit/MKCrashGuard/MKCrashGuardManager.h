/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "NSString+MKCrashGuard.h"
#import "NSMutableString+MKCrashGuard.h"
#import "NSMutableAttributedString+MKCrashGuard.h"
#import "NSObject+MKCrashGuard.h"
#import "NSArray+MKCrashGuard.h"
#import "NSMutableArray+MKCrashGuard.h"
#import "NSAttributedString+MKCrashGuard.h"
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
 默认防护所有的 "unrecognized selector sent to instance" crash,如果想按类名前缀进行防护，调用本方法即可。
 
 @param classPrefixs 需要防护的类名前缀
 */
+ (void)guardSelectorWithClassPrefixs:(NSArray<NSString *> *)classPrefixs;


//  DEBUG 模式下，crash 信息会打印出来，同时发送一个名为 @"MKCrashGuardErrorNotification" 的通知，用户可监听通知并进行上报处理等。


+ (void)exchangeClassMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;
+ (void)exchangeInstanceMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;
+ (void)printErrorInfo:(NSException *)exception describe:(NSString *)description;


@end
NS_ASSUME_NONNULL_END
