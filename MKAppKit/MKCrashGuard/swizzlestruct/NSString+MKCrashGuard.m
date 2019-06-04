/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSString+MKCrashGuard.h"
#import "MKCrashGuardManager.h"

MK_SYNTH_DUMMY_CLASS(NSString_MKCrashGuard)
@implementation NSString (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class mkNSCFConstantString = NSClassFromString(@"__NSCFConstantString");
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(characterAtIndex:) swizzledSelector:@selector(crashGuardCharacterAtIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(substringFromIndex:) swizzledSelector:@selector(crashGuardSubstringFromIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(substringToIndex:) swizzledSelector:@selector(crashGuardSubstringToIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(substringWithRange:) swizzledSelector:@selector(crashGuardSubstringWithRange:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(stringByReplacingOccurrencesOfString:withString:) swizzledSelector:@selector(crashGuardStringByReplacingOccurrencesOfString:withString:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) swizzledSelector:@selector(crashGuardStringByReplacingOccurrencesOfString:withString:options:range:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSCFConstantString systemSelector:@selector(stringByReplacingCharactersInRange:withString:) swizzledSelector:@selector(crashGuardStringByReplacingCharactersInRange:withString:)];
        
        Class mkNSTaggedPointerString = NSClassFromString(@"NSTaggedPointerString");
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(characterAtIndex:) swizzledSelector:@selector(crashGuardCharacterAtIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(substringFromIndex:) swizzledSelector:@selector(crashGuardSubstringFromIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(substringToIndex:) swizzledSelector:@selector(crashGuardSubstringToIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(substringWithRange:) swizzledSelector:@selector(crashGuardSubstringWithRange:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(stringByReplacingOccurrencesOfString:withString:) swizzledSelector:@selector(crashGuardStringByReplacingOccurrencesOfString:withString:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) swizzledSelector:@selector(crashGuardStringByReplacingOccurrencesOfString:withString:options:range:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSTaggedPointerString systemSelector:@selector(stringByReplacingCharactersInRange:withString:) swizzledSelector:@selector(crashGuardStringByReplacingCharactersInRange:withString:)];
        
        Class mkNSPlaceholderString = NSClassFromString(@"NSPlaceholderString");
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(characterAtIndex:) swizzledSelector:@selector(crashGuardCharacterAtIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(substringFromIndex:) swizzledSelector:@selector(crashGuardSubstringFromIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(substringToIndex:) swizzledSelector:@selector(crashGuardSubstringToIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(substringWithRange:) swizzledSelector:@selector(crashGuardSubstringWithRange:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(stringByReplacingOccurrencesOfString:withString:) swizzledSelector:@selector(crashGuardStringByReplacingOccurrencesOfString:withString:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) swizzledSelector:@selector(crashGuardStringByReplacingOccurrencesOfString:withString:options:range:)];
        [MKCrashGuardManager exchangeInstanceMethod:mkNSPlaceholderString systemSelector:@selector(stringByReplacingCharactersInRange:withString:) swizzledSelector:@selector(crashGuardStringByReplacingCharactersInRange:withString:)];
    });
}

#pragma mark - characterAtIndex:
- (unichar)crashGuardCharacterAtIndex:(NSUInteger)index {
    unichar characteristic;
    @try {
        characteristic = [self crashGuardCharacterAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *description = @"MKCrashGuard default is to return a without assign unichar.";
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return characteristic;
    }
}


#pragma mark - substringFromIndex:
- (NSString *)crashGuardSubstringFromIndex:(NSUInteger)from {
    NSString *subString = nil;
    @try {
        subString = [self crashGuardSubstringFromIndex:from];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

#pragma mark - substringToIndex
- (NSString *)crashGuardSubstringToIndex:(NSUInteger)to {
    NSString *subString = nil;
    @try {
        subString = [self crashGuardSubstringToIndex:to];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        subString = nil;
    }
    @finally {
        return subString;
    }
}


#pragma mark - substringWithRange:
- (NSString *)crashGuardSubstringWithRange:(NSRange)range {
    NSString *subString = nil;
    @try {
        subString = [self crashGuardSubstringWithRange:range];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:
- (NSString *)crashGuardStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self crashGuardStringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}


#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:
- (NSString *)crashGuardStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *newStr = nil;
    @try {
        newStr = [self crashGuardStringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}


#pragma mark - stringByReplacingCharactersInRange:withString:
- (NSString *)crashGuardStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self crashGuardStringByReplacingCharactersInRange:range withString:replacement];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
} 

@end
