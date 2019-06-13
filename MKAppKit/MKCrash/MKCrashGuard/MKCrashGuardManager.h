/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

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

#import "NSTimer+MKCrashGuard.h"
#import "NSObject+MKNotificationCrashGuard.h"
#import "NSObject+MKKVOCrashGuard.h"
#import "NSObject+MKSELCrashGuard.h"
#import "NSObject+MKKVCCrashGuard.h"

#import "UINavigationController+MKCrashGuard.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger,MKCrashGuardType) {
    MKCrashGuardTypeNone = 0,
    MKCrashGuardTypeUnrecognizedSelector = 1 << 1,
    MKCrashGuardTypeKVOCrash = 1 << 2,
    MKCrashGuardTypeKVCCrash = 1 << 3,
    MKCrashGuardTypeNSTimer = 1 << 4,
    MKCrashGuardTypeNSNotification = 1 << 5,
    MKCrashGuardTypeNSNull = 1 << 6,
    
    MKCrashGuardTypeUINavigationController = 1 << 7,
    
    MKCrashGuardTypeNSStringContainer = 1 << 8,
    MKCrashGuardTypeDictionaryContainer = 1 << 9,
    MKCrashGuardTypeArrayContainer = 1 << 10,
    MKCrashGuardTypeNSAttributedStringContainer = 1 << 11,
    MKCrashGuardTypeNSSetContainer = 1 << 12,
    
    MKCrashGuardTypeAllExceptUIAndContainer = MKCrashGuardTypeUnrecognizedSelector | MKCrashGuardTypeKVOCrash | MKCrashGuardTypeKVCCrash | MKCrashGuardTypeNSTimer | MKCrashGuardTypeNSNotification | MKCrashGuardTypeNSNull,
    MKCrashGuardTypeAllExceptContainer = MKCrashGuardTypeUnrecognizedSelector | MKCrashGuardTypeKVOCrash | MKCrashGuardTypeKVCCrash | MKCrashGuardTypeNSTimer | MKCrashGuardTypeNSNotification | MKCrashGuardTypeNSNull | MKCrashGuardTypeUINavigationController,
    MKCrashGuardTypeAllContainer = MKCrashGuardTypeNSStringContainer | MKCrashGuardTypeDictionaryContainer | MKCrashGuardTypeArrayContainer | MKCrashGuardTypeNSAttributedStringContainer | MKCrashGuardTypeNSSetContainer ,
    MKCrashGuardTypeAll = MKCrashGuardTypeAllContainer | MKCrashGuardTypeAllExceptContainer ,
};


@protocol MKExceptionHandle<NSObject>

/**
 * 调用 registerCrashHandle: 注册之后, 回调 crash 信息
 */
- (void)handleCrashException:(nonnull NSString *)exceptionMessage extraInfo:(nullable NSDictionary*)extraInfo;

@end


@interface MKCrashGuardManager : NSObject

/**
 * 启动 App 守护,默认守护所有的类型:MKCrashGuardTypeAll
 */
+ (void)executeAppGuard;

/**
 * 启动 App 守护,自定义守护的类型
 * eg : [MKCrashGuardManager executeAppGuardWithConfig: MKCrashGuardTypeNSNull | MKCrashGuardTypeNSNotification | MKCrashGuardTypeAllContainer];
 */
+ (void)executeAppGuardWithConfig:(MKCrashGuardType)crashGuardType;

/**
 * 注册 crash 信息的回调对象,可在回调中保存、上报 crash 日志
 */
+ (void)registerCrashHandle:(id<MKExceptionHandle>)crashHandle;

/**
 * 开启 log
 * @param isLog 是否开启log
 */
+ (void)printLog:(BOOL)isLog;


+ (void)exchangeClassMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));
+ (void)exchangeInstanceMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));

@end
NS_ASSUME_NONNULL_END




