/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h> 

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MKCrashGuard)

/**
 * 支持一种防护
 * +(instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt  快速创建方式
 *
 */
+ (void)crashGuardExchangeMethod;

@end

NS_ASSUME_NONNULL_END
