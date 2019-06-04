/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableString+MKCrashGuard.h"
#import "MKCrashGuardManager.h"

@implementation NSMutableString (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class stringClass = NSClassFromString(@"__NSCFString");
        //replaceCharactersInRange
        [MKCrashGuardManager exchangeInstanceMethod:stringClass systemSelector:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(crashGuardReplaceCharactersInRange:withString:)];
        //insertString:atIndex:
        [MKCrashGuardManager exchangeInstanceMethod:stringClass systemSelector:@selector(insertString:atIndex:) swizzledSelector:@selector(crashGuardInsertString:atIndex:)];
        //deleteCharactersInRange
        [MKCrashGuardManager exchangeInstanceMethod:stringClass systemSelector:@selector(deleteCharactersInRange:) swizzledSelector:@selector(crashGuardDeleteCharactersInRange:)];
    });
}


#pragma mark - replaceCharactersInRange
- (void)crashGuardReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self crashGuardReplaceCharactersInRange:range withString:aString];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
    }
}


#pragma mark - insertString:atIndex:
- (void)crashGuardInsertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        [self crashGuardInsertString:aString atIndex:loc];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
    }
}

#pragma mark - deleteCharactersInRange
- (void)crashGuardDeleteCharactersInRange:(NSRange)range {
    @try {
        [self crashGuardDeleteCharactersInRange:range];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally { 
    }
}








@end
