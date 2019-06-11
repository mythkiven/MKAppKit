/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/11.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNull (MKCrashGuard)

/**
 * 防护 重复跳转
 */
+ (void)guardNSNull;

@end

NS_ASSUME_NONNULL_END
