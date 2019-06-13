/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (MKCrashGuard) 

/** 防护：
 *
 * - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 * - (void)removeObjectForKey:(id)aKey
 *
 */
+ (void)crashGuardExchangeMethod;
@end

NS_ASSUME_NONNULL_END


