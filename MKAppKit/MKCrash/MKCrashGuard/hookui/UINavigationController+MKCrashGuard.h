/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/11.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (MKCrashGuard)

/**
 * 防护 重复跳转
 */
+ (void)guardNavigationController;

@end

NS_ASSUME_NONNULL_END
