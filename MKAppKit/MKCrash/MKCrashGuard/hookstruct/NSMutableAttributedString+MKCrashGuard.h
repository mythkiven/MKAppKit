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
 *  - (void)addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range;
 *  - (void)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs range:(NSRange)range;
 *  - (void)setAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs range:(NSRange)range;
 *  - (void)removeAttribute:(NSAttributedStringKey)name range:(NSRange)range;
 *  - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str;
 *  - (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString; 
 *  - (void)deleteCharactersInRange:(NSRange)range;
 */
+ (void)crashGuardExchangeMethod;
@end

NS_ASSUME_NONNULL_END


