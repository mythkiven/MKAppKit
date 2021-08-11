/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (MKCrashGuard) 

/** 防护：
 *
 *  - (id)objectAtIndex:(NSUInteger)index
 *  - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  - (void)removeObjectAtIndex:(NSUInteger)index
 *  - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *  - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 *  - (NSArray<ObjectType> *)subarrayWithRange:(NSRange)range;
 *  - (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx
 *  - (void)addObject:(ObjectType)anObject;
 *  - (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;
 */
+ (void)crashGuardExchangeMethod;

@end

NS_ASSUME_NONNULL_END


