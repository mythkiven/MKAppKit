/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSAttributedString+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"


MK_SYNTH_DUMMY_CLASS(NSAttributedString_MKCrashGuard)
@implementation NSAttributedString (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
    mk_swizzleInstanceMethod(NSConcreteAttributedString,@selector(initWithString:),@selector(guardInitWithString:));
    mk_swizzleInstanceMethod(NSConcreteAttributedString,@selector(initWithAttributedString:),@selector(guardInitWithAttributedString:));
    mk_swizzleInstanceMethod(NSConcreteAttributedString,@selector(initWithString:attributes:),@selector(guardInitWithString:attributes:));
    
    mk_swizzleInstanceMethod(NSConcreteAttributedString, @selector(attributedSubstringFromRange:), @selector(guardAttributedSubstringFromRange:));
    mk_swizzleInstanceMethod(NSConcreteAttributedString, @selector(attribute:atIndex:effectiveRange:), @selector(guardAttribute:atIndex:effectiveRange:));
    mk_swizzleInstanceMethod(NSConcreteAttributedString, @selector(enumerateAttribute:inRange:options:usingBlock:), @selector(guardEnumerateAttribute:inRange:options:usingBlock:));
    mk_swizzleInstanceMethod(NSConcreteAttributedString, @selector(enumerateAttributesInRange:options:usingBlock:), @selector(guardEnumerateAttributesInRange:options:usingBlock:));
    
}

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
- (instancetype)guardInitWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    @try {
        object = [self guardInitWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        return object;
    }
}
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
- (id)guardAttribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range {
    if (location < self.length){
        return [self guardAttribute:attrName atIndex:location effectiveRange:range];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSAttributedString attribute:atIndex:effectiveRange: ] attrName:%@ location:%tu",attrName,location]);
    return nil;
}
- (NSAttributedString *)guardAttributedSubstringFromRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        return [self guardAttributedSubstringFromRange:range];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSAttributedString attributedSubstringFromRange:] range: %@",NSStringFromRange(range)]);
    return nil;
}
- (void)guardEnumerateAttribute:(NSString *)attrName inRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(id _Nullable, NSRange, BOOL * _Nonnull))block {
    if (range.location + range.length <= self.length) {
        [self guardEnumerateAttribute:attrName inRange:range options:opts usingBlock:block];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSAttributedString enumerateAttribute inRange: options:] attrName:%@ range:%@",attrName,NSStringFromRange(range)]);
    }
} 
- (void)guardEnumerateAttributesInRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(NSDictionary<NSString*,id> * _Nonnull, NSRange, BOOL * _Nonnull))block {
    if (range.location + range.length <= self.length) {
        [self guardEnumerateAttributesInRange:range options:opts usingBlock:block];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSAttributedString enumerateAttributesInRange: options: usingBlock: ] range:%@",NSStringFromRange(range)]);
    }
}

@end
