/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableAttributedString+MKCrashGuard.h" 
#import "MKCrashGuardManager.h"

@implementation NSMutableAttributedString (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        //initWithString:
        [MKCrashGuardManager exchangeInstanceMethod:NSConcreteMutableAttributedString systemSelector:@selector(initWithString:) swizzledSelector:@selector(crashGuardInitWithString:)];
        //initWithString:attributes:
        [MKCrashGuardManager exchangeInstanceMethod:NSConcreteMutableAttributedString systemSelector:@selector(initWithString:attributes:) swizzledSelector:@selector(crashGuardInitWithString:attributes:)];
    });
}


#pragma mark - initWithString:
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

#pragma mark - initWithString:attributes:
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
