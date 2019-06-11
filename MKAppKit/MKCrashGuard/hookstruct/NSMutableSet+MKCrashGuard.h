/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableSet (MKCrashGuard)
/** 防护
 *
 * - (void)addObject:(ObjectType)object;
 * - (void)removeObject:(ObjectType)object;
 */
+ (void)crashGuardExchangeMethod;
@end

NS_ASSUME_NONNULL_END
