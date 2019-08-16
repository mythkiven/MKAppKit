/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/16.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#define MKLOCKGUARD(lock) \
MKLockSentinel *_guard_ = [[MKLockSentinel alloc] initWithLock:lock];\
NSAssert(_guard_, @"_guard_ invaild");

NS_ASSUME_NONNULL_BEGIN

@interface MKLockSentinel : NSObject

/**
 哨兵类，使用方式：
  MKLOCKGUARD(lock)。
    注意：哨兵类在作用域结束会自动释放，有疑问可以尝试在dealloc中log。

 @param obj NSLock
 @return MKLockSentinel
 */
- (id)initWithLock:(id<NSLocking>)obj;
@end

NS_ASSUME_NONNULL_END
