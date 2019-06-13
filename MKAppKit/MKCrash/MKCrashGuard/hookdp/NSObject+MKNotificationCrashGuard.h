/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MKNotificationCrashGuard)

/**
 * 防护 添加 通知后，没有删除导致的 crash 
 */
+ (void)guardNotificationCrash;

@end

NS_ASSUME_NONNULL_END
