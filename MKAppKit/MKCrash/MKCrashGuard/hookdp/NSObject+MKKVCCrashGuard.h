/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/11.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MKKVCCrashGuard)

/** 防护如下方法
 * - (void)setValue:(nullable id)value forKey:(NSString *)key;
 * - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;
 * - (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
 * - (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;
 */
+ (void)guardKVCCrash;

@end

NS_ASSUME_NONNULL_END
