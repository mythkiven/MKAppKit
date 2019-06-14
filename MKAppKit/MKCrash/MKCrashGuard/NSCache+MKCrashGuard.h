/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/13.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCache (MKCrashGuard)

/*
 可避免以下crash
 setObject:forKey:
 setObject:forKey:cost:
 
 */
+ (void)guardNSCacheCrash;

@end

NS_ASSUME_NONNULL_END
