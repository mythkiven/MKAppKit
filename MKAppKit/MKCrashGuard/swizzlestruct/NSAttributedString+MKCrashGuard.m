/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSAttributedString+MKCrashGuard.h" 
#import "MKCrashGuardManager.h"

MK_SYNTH_DUMMY_CLASS(NSAttributedString_MKCrashGuard)
@implementation NSAttributedString (MKCrashGuard)


#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        [MKCrashGuardManager exchangeInstanceMethod:NSConcreteAttributedString systemSelector:@selector(initWithString:) swizzledSelector:@selector(crashGuardInitWithString:)];
        [MKCrashGuardManager exchangeInstanceMethod:NSConcreteAttributedString systemSelector:@selector(initWithAttributedString:) swizzledSelector:@selector(crashGuardInitWithAttributedString:)];
        [MKCrashGuardManager exchangeInstanceMethod:NSConcreteAttributedString systemSelector:@selector(initWithString:attributes:) swizzledSelector:@selector(crashGuardInitWithString:attributes:)];
    });
}

#pragma mark  initWithString
- (instancetype)crashGuardInitWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self crashGuardInitWithString:str];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}

#pragma mark initWithAttributedString
- (instancetype)crashGuardInitWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    @try {
        object = [self crashGuardInitWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}

#pragma mark initWithString:attributes:

- (instancetype)crashGuardInitWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    @try {
        object = [self crashGuardInitWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}

@end
