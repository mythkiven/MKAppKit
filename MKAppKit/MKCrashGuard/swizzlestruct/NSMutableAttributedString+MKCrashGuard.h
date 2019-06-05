/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (MKCrashGuard) 

/** 防护：
 *
 *  - (instancetype)initWithString:(NSString *)str
 *  - (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 *
 */
+ (void)crashGuardExchangeMethod;
@end

NS_ASSUME_NONNULL_END


