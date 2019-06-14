/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/13.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (MKCrashGuard)

/*
 可避免以下方法  key=nil时的crash
 1.objectForKey:
 2.stringForKey:
 3.arrayForKey:
 4.dataForKey:
 5.URLForKey:
 6.stringArrayForKey:
 7.floatForKey:
 8.doubleForKey:
 9.integerForKey:
 10.boolForKey:
 11.setObject:forKey:
 */
+ (void)guardUserDefaultsCrash;

@end

NS_ASSUME_NONNULL_END
