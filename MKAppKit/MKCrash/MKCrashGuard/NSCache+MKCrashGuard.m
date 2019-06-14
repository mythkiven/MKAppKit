/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/13.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "NSCache+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>

MK_SYNTH_DUMMY_CLASS(NSCache_MKSELCrashGuard)
@implementation NSCache (MKCrashGuard)


+ (void)guardNSCacheCrash {
    mk_swizzleInstanceMethod(NSClassFromString(@"NSCache"),@selector(setObject:forKey:),@selector(guard_setObject:forKey:));
    mk_swizzleInstanceMethod(NSClassFromString(@"NSCache"),@selector(setObject:forKey:cost:),@selector(guard_setObject:forKey:cost:));
}

- (void)guard_setObject:(id)obj forKey:(id)key {
    if(key&&obj){
        [self guard_setObject:obj forKey:key];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSCache %@ key and value can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
}
- (void)guard_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g {
    if(key&&obj){
        [self guard_setObject:obj forKey:key cost:g];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSCache %@ key and value can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
}

@end
