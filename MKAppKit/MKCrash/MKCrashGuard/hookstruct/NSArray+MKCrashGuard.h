/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (MKCrashGuard) 

/** 防护：
 *
 *  + (instancetype)arrayWithObjects:(const ObjectType _Nonnull [_Nonnull])objects count:(NSUInteger)cnt; 即 快速创建方式
 *  - (id)objectAtIndex:(NSUInteger)index
 *  - (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
 *  - (ObjectType)objectAtIndex:(NSUInteger)index;
 *  - (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx
 * - (void)getObjects:(ObjectType _Nonnull __unsafe_unretained [_Nonnull])objects range:(NSRange)range
 *
 */
+ (void)crashGuardExchangeMethod;

@end

NS_ASSUME_NONNULL_END


