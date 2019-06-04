/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "MKCrashGuardProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (MKCrashGuard)<MKCrashGuardProtocol>

/** 防护：
 *
 * - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 * - (void)removeObjectForKey:(id)aKey
 *
 */

@end

NS_ASSUME_NONNULL_END


