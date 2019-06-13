/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (MKCrashGuard)

/**
 * 防护 强引用 以及 target 提前销毁
 *
 */

+ (void)guardTimerCrash;

@end

NS_ASSUME_NONNULL_END
