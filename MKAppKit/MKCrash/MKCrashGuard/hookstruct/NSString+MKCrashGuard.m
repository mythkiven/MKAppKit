/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSString+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSString_MKCrashGuard)
@implementation NSString (MKCrashGuard)

+ (void)crashGuardExchangeMethod {
    [NSString mk_swizzleClassMethod:@selector(stringWithUTF8String:) withSwizzleMethod:@selector(guardStringWithUTF8String:)];
    [NSString mk_swizzleClassMethod:@selector(stringWithCString:encoding:) withSwizzleMethod:@selector(guardStringWithCString:encoding:)];

    //NSPlaceholderString
    mk_swizzleInstanceMethod(NSClassFromString(@"NSPlaceholderString"), @selector(initWithCString:encoding:), @selector(guardInitWithCString:encoding:));
    mk_swizzleInstanceMethod(NSClassFromString(@"NSPlaceholderString"), @selector(initWithString:), @selector(guardInitWithString:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(characterAtIndex:), @selector(guardCharacterAtIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:), @selector(guardStringByReplacingOccurrencesOfString:withString:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:options:range:), @selector(guardStringByReplacingOccurrencesOfString:withString:options:range:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingCharactersInRange:withString:), @selector(guardStringByReplacingCharactersInRange:withString:));

    //_NSCFConstantString
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringFromIndex:), @selector(guardSubstringFromIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringToIndex:), @selector(guardSubstringToIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringWithRange:), @selector(guardSubstringWithRange:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(rangeOfString:options:range:locale:), @selector(guardRangeOfString:options:range:locale:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(characterAtIndex:), @selector(guardCharacterAtIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:), @selector(guardStringByReplacingOccurrencesOfString:withString:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:options:range:), @selector(guardStringByReplacingOccurrencesOfString:withString:options:range:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingCharactersInRange:withString:), @selector(guardStringByReplacingCharactersInRange:withString:));
    
    //NSTaggedPointerString
    mk_swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringFromIndex:), @selector(guardSubstringFromIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringToIndex:), @selector(guardSubstringToIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringWithRange:), @selector(guardSubstringWithRange:));
    mk_swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(rangeOfString:options:range:locale:), @selector(guardRangeOfString:options:range:locale:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(characterAtIndex:), @selector(guardCharacterAtIndex:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:), @selector(guardStringByReplacingOccurrencesOfString:withString:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:options:range:), @selector(guardStringByReplacingOccurrencesOfString:withString:options:range:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingCharactersInRange:withString:), @selector(guardStringByReplacingCharactersInRange:withString:));
    
}


- (unichar)guardCharacterAtIndex:(NSUInteger)index {
    unichar characteristic;
    @try {
        characteristic = [self guardCharacterAtIndex:index];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        return characteristic;
    }
}
- (NSString *)guardStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self guardStringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}
- (NSString *)guardStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *newStr = nil;
    @try {
        newStr = [self guardStringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}
- (NSString *)guardStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self guardStringByReplacingCharactersInRange:range withString:replacement];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}
+ (NSString*) guardStringWithUTF8String:(const char *)nullTerminatedCString{
    if (NULL != nullTerminatedCString) {
        return [self guardStringWithUTF8String:nullTerminatedCString];
    }
    mkHandleCrashException(@"[NSString stringWithUTF8String :] NULL char pointer");
    return nil;
}

+ (nullable instancetype) guardStringWithCString:(const char *)cString encoding:(NSStringEncoding)enc
{
    if (NULL != cString){
        return [self guardStringWithCString:cString encoding:enc];
    }
    mkHandleCrashException(@"[NSString stringWithCString:encoding: ] NULL char pointer");
    return nil;
}

- (nullable instancetype) guardInitWithString:(id)cString{
    if (nil != cString){
        return [self guardInitWithString:cString];
    }
    mkHandleCrashException(@"[NSString initWithString :] nil parameter");
    return nil;
}

- (nullable instancetype) guardInitWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding{
    if (NULL != nullTerminatedCString){
        return [self guardInitWithCString:nullTerminatedCString encoding:encoding];
    }
    mkHandleCrashException(@"[NSString initWithCString:encoding :] NULL char pointer");
    return nil;
}

- (NSString *)guardSubstringFromIndex:(NSUInteger)from{
    if (from <= self.length) {
        return [self guardSubstringFromIndex:from];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSString substringFromIndex :] value:%@ from:%tu",self,from]);
    return nil;
}

- (NSString *)guardSubstringToIndex:(NSUInteger)to{
    if (to <= self.length) {
        return [self guardSubstringToIndex:to];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSString substringToIndex :] value:%@ from:%tu",self,to]);
    return self;
}

- (NSString *)guardSubstringWithRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self guardSubstringWithRange:range];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSString substringWithRange :] value:%@ range:%@",self,NSStringFromRange(range)]);
    return nil;
}
- (NSRange)guardRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)range locale:(nullable NSLocale *)locale{
    if (searchString){
        if (range.location + range.length <= self.length) {
            return [self guardRangeOfString:searchString options:mask range:range locale:locale];
        }
        mkHandleCrashException([NSString stringWithFormat:@"[NSString rangeOfString:options:range:locale: ] value:%@ range:%@",self,NSStringFromRange(range)]);
        return NSMakeRange(NSNotFound, 0);
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSString rangeOfString:options:range:locale: ] searchString nil value:%@ range:%@",self,NSStringFromRange(range)]);
        return NSMakeRange(NSNotFound, 0);
    }
}

@end
