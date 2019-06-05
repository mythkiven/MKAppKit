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
    
}

#pragma mark  initWithString
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

#pragma mark initWithAttributedString
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

#pragma mark initWithString:attributes:

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

@end
