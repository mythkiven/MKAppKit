/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (MKCrashGuard)

/** 防护： 
 *
 *  - (instancetype)initWithString:(NSString *)str
 *  - (instancetype)initWithAttributedString:(NSAttributedString *)attrStr
 *  - (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 *  - (NSAttributedString *)attributedSubstringFromRange:(NSRange)range;
 *  - (nullable id)attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range;
 *  - (void)enumerateAttributesInRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(NSDictionary<NSAttributedStringKey, id> *attrs, NSRange range, BOOL *stop))block;
 *  - (void)enumerateAttribute:(NSAttributedStringKey)attrName inRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(id _Nullable value, NSRange range, BOOL *stop))block;
 */

+ (void)crashGuardExchangeMethod;
@end

NS_ASSUME_NONNULL_END

