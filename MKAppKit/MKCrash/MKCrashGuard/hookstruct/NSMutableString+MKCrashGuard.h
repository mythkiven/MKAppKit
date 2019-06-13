/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (MKCrashGuard)

/**  防护：
 *
 * - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
 * - (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc
 * - (void)deleteCharactersInRange:(NSRange)range
 * - (void)appendString:(NSString *)aString;
 * - (NSString *)substringFromIndex:(NSUInteger)from;
 * - (NSString *)substringToIndex:(NSUInteger)to;
 * - (NSString *)substringWithRange:(NSRange)range;   
 */
+ (void)crashGuardExchangeMethod;

@end

NS_ASSUME_NONNULL_END





