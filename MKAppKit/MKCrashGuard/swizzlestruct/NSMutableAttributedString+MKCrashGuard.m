/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableAttributedString+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSMutableAttributedString_MKCrashGuard)
@implementation NSMutableAttributedString (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(initWithString:),@selector(guardInitWithString:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(initWithString:attributes:),@selector(guardInitWithString:attributes:));
    
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(addAttribute:value:range:), @selector(guardAddAttribute:value:range:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(addAttributes:range:), @selector(guardAddAttributes:range:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(setAttributes:range:), @selector(guardSetAttributes:range:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(removeAttribute:range:), @selector(guardRemoveAttribute:range:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(deleteCharactersInRange:), @selector(guardDeleteCharactersInRange:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(replaceCharactersInRange:withString:), @selector(guardReplaceCharactersInRange:withString:));
    mk_swizzleInstanceMethod(NSConcreteMutableAttributedString,@selector(replaceCharactersInRange:withAttributedString:), @selector(guardReplaceCharactersInRange:withAttributedString:));
    
}


#pragma mark - initWithString:
- (instancetype)guardInitWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self guardInitWithString:str];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:
- (instancetype)guardInitWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    @try {
        object = [self guardInitWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        return object;
    }
}

- (void)guardAddAttribute:(id)name value:(id)value range:(NSRange)range {
    if (!range.length) {
        [self guardAddAttribute:name value:value range:range];
    }else if (value){
        if (range.location + range.length <= self.length) {
            [self guardAddAttribute:name value:value range:range];
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString addAttribute:value:range: name:%@ value:%@ range:%@",name,value,NSStringFromRange(range)]);
        }
    }else {
        mkHandleCrashException(@"NSMutableAttributedString addAttribute:value:range: value nil");
    }
}
- (void)guardAddAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    if (!range.length) {
        [self guardAddAttributes:attrs range:range];
    }else if (attrs){
        if (range.location + range.length <= self.length) {
            [self guardAddAttributes:attrs range:range];
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString addAttributes:range: attrs:%@ range:%@",attrs,NSStringFromRange(range)]);
        }
    }else{
        mkHandleCrashException(@"NSMutableAttributedString addAttributes:range: value nil");
    }
}

- (void)guardSetAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    if (!range.length) {
        [self guardSetAttributes:attrs range:range];
    }else if (attrs){
        if (range.location + range.length <= self.length) {
            [self guardSetAttributes:attrs range:range];
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString setAttributes:range: attrs:%@ range:%@",attrs,NSStringFromRange(range)]);
        }
    }else{
        mkHandleCrashException(@"NSMutableAttributedString setAttributes:range: attrs nil");
    }
}

- (void)guardRemoveAttribute:(id)name range:(NSRange)range {
    if (!range.length) {
        [self guardRemoveAttribute:name range:range];
    }else if (name){
        if (range.location + range.length <= self.length) {
            [self guardRemoveAttribute:name range:range];
        }else {
            mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString removeAttribute:range: name:%@ range:%@",name,NSStringFromRange(range)]);
        }
    }else{
        mkHandleCrashException(@"NSMutableAttributedString removeAttribute:range: attrs nil");
    }
}

- (void)guardDeleteCharactersInRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        [self guardDeleteCharactersInRange:range];
    }else {
        mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString deleteCharactersInRange: range:%@",NSStringFromRange(range)]);
    }
}
- (void)guardReplaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    if (str){
        if (range.location + range.length <= self.length) {
            [self guardReplaceCharactersInRange:range withString:str];
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString replaceCharactersInRange:withString string:%@ range:%@",str,NSStringFromRange(range)]);
        }
    }else{
        mkHandleCrashException(@"NSMutableAttributedString replaceCharactersInRange:withString: string nil");
    }
}
- (void)guardReplaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)str {
    if (str){
        if (range.location + range.length <= self.length) {
            [self guardReplaceCharactersInRange:range withAttributedString:str];
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"NSMutableAttributedString replaceCharactersInRange:withString string:%@ range:%@",str,NSStringFromRange(range)]);
        }
    }else{
        mkHandleCrashException(@"NSMutableAttributedString replaceCharactersInRange:withString: attributedString nil");
    }
}
@end
