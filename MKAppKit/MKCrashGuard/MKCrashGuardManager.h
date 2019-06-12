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

#import "NSTimer+MKCrashGuard.h"
#import "NSObject+MKNotificationCrashGuard.h"
#import "NSObject+MKKVOCrashGuard.h"
#import "NSObject+MKSELCrashGuard.h"
#import "NSObject+MKKVCCrashGuard.h"

#import "UINavigationController+MKCrashGuard.h"
NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSInteger,MKCrashGuardType){
    MKCrashGuardTypeNone = 0,
    MKCrashGuardTypeUnrecognizedSelector,
    MKCrashGuardTypeKVOCrash,
    MKCrashGuardTypeKVCCrash,
    MKCrashGuardTypeNSTimer,
    MKCrashGuardTypeNSNotification,
    MKCrashGuardTypeNSNull,
    
    MKCrashGuardTypeUINavigationController,
    
    MKCrashGuardTypeNSStringContainer,
    MKCrashGuardTypeDictionaryContainer,
    MKCrashGuardTypeArrayContainer,
    MKCrashGuardTypeNSAttributedStringContainer,
    MKCrashGuardTypeNSSetContainer,
    
    MKCrashGuardTypeAllExceptContainer = MKCrashGuardTypeUnrecognizedSelector | MKCrashGuardTypeKVOCrash | MKCrashGuardTypeKVCCrash | MKCrashGuardTypeNSTimer | MKCrashGuardTypeNSNotification | MKCrashGuardTypeNSNull | MKCrashGuardTypeUINavigationController,
    MKCrashGuardTypeAllContainer = MKCrashGuardTypeNSStringContainer | MKCrashGuardTypeDictionaryContainer | MKCrashGuardTypeArrayContainer | MKCrashGuardTypeNSAttributedStringContainer | MKCrashGuardTypeNSSetContainer ,
    MKCrashGuardTypeAll = MKCrashGuardTypeAllContainer | MKCrashGuardTypeAllExceptContainer ,
};



@interface MKCrashGuardManager : NSObject

/**
 * 启动 App 守护,守护所有类型的crash
 */
+ (void)executeAppGuard;

/**
 * 自行配置守护的类型
 */
+ (void)configAppGuard:(MKCrashGuardType)crashGuardType;


+ (void)exchangeClassMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));
+ (void)exchangeInstanceMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;//  __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur crash")));

@end
NS_ASSUME_NONNULL_END




