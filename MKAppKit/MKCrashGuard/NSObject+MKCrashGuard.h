/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MKCrashGuard)

/**  防护：
 *
 *  - (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;
 *  - (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
 *  - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;
 *  - (void)setValue:(nullable id)value forKey:(NSString *)key;
 *
 *  - (id)forwardingTargetForSelector:(SEL)aSelector
 *  - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 
 */



/**
 防护 Unrecognized
 @param isGuardUnrecognized 是否防护 Unrecognized
 */
+ (void)mk_guardSelector:(BOOL)isGuardUnrecognized;


/**
 防护 Unrecognized
 @param classPrefixs 需要防护的类名或类名前缀
 */
+ (void)mk_guardSelectorWithClassPrefixs:(NSArray<NSString *> *)classPrefixs;

@end

NS_ASSUME_NONNULL_END
