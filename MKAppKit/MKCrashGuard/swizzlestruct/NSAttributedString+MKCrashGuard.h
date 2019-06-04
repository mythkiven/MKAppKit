/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "MKCrashGuardProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (MKCrashGuard)<MKCrashGuardProtocol>

/** 防护： 
 *
 *  - (instancetype)initWithString:(NSString *)str
 *  - (instancetype)initWithAttributedString:(NSAttributedString *)attrStr
 *  - (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 *
 */

@end

NS_ASSUME_NONNULL_END

