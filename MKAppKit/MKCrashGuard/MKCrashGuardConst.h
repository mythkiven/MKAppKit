/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define MKCrashGuardNotification @"MKCrashGuardErrorNotification"
#define MKCrashGuardSystemVersion(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)


#define MKCrashGuardDefaultReturnNil  @"MKCrashGuard default  to return nil"
#define MKCrashGuardDefaultIgnore     @"MKCrashGuard default  to ignore this operation"

#define MKCrashGuardSeparator         @"================================================================\n\n\n"
#define MKCrashGuardSeparatorWithFlag @"\n\n\n======================== MKCrashGuard Log =========================="


#ifdef DEBUG
#define MKCrashGuardLog(fmt, ...) NSLog((@"MKCrashGuardLog:" fmt), ##__VA_ARGS__)
#else 
#define MKCrashGuardLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN
@interface MKCrashGuardConst : NSObject

- (void)mkProxyMethod;

@end
NS_ASSUME_NONNULL_END
