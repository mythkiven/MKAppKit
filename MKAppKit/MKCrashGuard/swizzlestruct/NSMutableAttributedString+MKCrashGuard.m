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
@end
