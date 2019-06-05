/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h> 

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MKCrashGuard)

/** 防护
 *
 *  - (unichar)characterAtIndex:(NSUInteger)index
 *  - (NSString *)substringFromIndex:(NSUInteger)from
 *  - (NSString *)substringToIndex:(NSUInteger)to {
 *  - (NSString *)substringWithRange:(NSRange)range {
 *  - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
 *  - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
 *  - (NSString *)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
 *
 */
+ (void)crashGuardExchangeMethod;
@end

NS_ASSUME_NONNULL_END


