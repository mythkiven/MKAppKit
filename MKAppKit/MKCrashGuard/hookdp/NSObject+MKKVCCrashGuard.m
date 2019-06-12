/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/11.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSObject+MKKVCCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>


MK_SYNTH_DUMMY_CLASS(NSObject_MKKVCCrashGuard)
@implementation NSObject (MKKVCCrashGuard)


+ (void)guardKVCCrash {
    
    mk_swizzleInstanceMethod([self class], @selector(setValue:forKey:),@selector(crashGuardSetValue:forKey:));
    mk_swizzleInstanceMethod([self class], @selector(setValue:forKeyPath:),@selector(crashGuardSetValue:forKeyPath:));
    mk_swizzleInstanceMethod([self class], @selector(setValue:forUndefinedKey:),@selector(crashGuardSetValue:forUndefinedKey:));
    mk_swizzleInstanceMethod([self class], @selector(setValuesForKeysWithDictionary:),@selector(crashGuardSetValuesForKeysWithDictionary:)); 
 
}

- (void)crashGuardSetValue:(id)value forKey:(NSString *)key {
    @try {
        [self crashGuardSetValue:value forKey:key];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        
    }
}

- (void)crashGuardSetValue:(id)value forKeyPath:(NSString *)keyPath {
    @try {
        [self crashGuardSetValue:value forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        
    }
}

- (void)crashGuardSetValue:(id)value forUndefinedKey:(NSString *)key {
    @try {
        [self crashGuardSetValue:value forUndefinedKey:key];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        
    }
}


- (void)crashGuardSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    @try {
        [self crashGuardSetValuesForKeysWithDictionary:keyedValues];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
        
    }
}


@end
