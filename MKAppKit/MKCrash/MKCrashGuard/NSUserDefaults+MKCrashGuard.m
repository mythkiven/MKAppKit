/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/13.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSUserDefaults+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>

MK_SYNTH_DUMMY_CLASS(NSUserDefaults_MKSELCrashGuard)
@implementation NSUserDefaults (MKCrashGuard)

+ (void)guardUserDefaultsCrash {
    Class userDefaults=NSClassFromString(@"NSUserDefaults");
    mk_swizzleInstanceMethod(userDefaults,@selector(setObject:forKey:),@selector(guard_setObject:forKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(objectForKey:),@selector(guard_objectForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(stringForKey:),@selector(guard_stringForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(arrayForKey:),@selector(guard_arrayForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(dataForKey:),@selector(guard_dataForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(URLForKey:),@selector(guard_URLForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(stringArrayForKey:),@selector(guard_stringArrayForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(floatForKey:),@selector(guard_floatForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(doubleForKey:),@selector(guard_doubleForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(integerForKey:),@selector(guard_integerForKey:));
    mk_swizzleInstanceMethod(userDefaults,@selector(boolForKey:),@selector(guard_boolForKey:));
    
}

- (void)guard_setObject:(id)value forKey:(NSString *)defaultName {
    if(!defaultName){
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key  can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }else{
        [self guard_setObject:value forKey:defaultName];
    }
}

- (id)guard_objectForKey:(NSString *)defaultName {
    id obj=nil;
    if(defaultName){
        obj=[self guard_objectForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (NSString *)guard_stringForKey:(NSString *)defaultName {
    id obj=nil;
    if(defaultName){
        obj=[self guard_stringForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (NSArray *)guard_arrayForKey:(NSString *)defaultName {
    id obj=nil;
    if(defaultName){
        obj=[self guard_arrayForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (NSData *)guard_dataForKey:(NSString *)defaultName {
    id obj=nil;
    if(defaultName){
        obj=[self guard_dataForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (NSURL *)guard_URLForKey:(NSString *)defaultName {
    id obj=nil;
    if(defaultName){
        obj=[self guard_URLForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (NSArray<NSString *> *)guard_stringArrayForKey:(NSString *)defaultName {
    id obj=nil;
    if(defaultName){
        obj=[self guard_stringArrayForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (float)guard_floatForKey:(NSString *)defaultName {
    float obj=0;
    if(defaultName){
        obj=[self guard_floatForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (double)guard_doubleForKey:(NSString *)defaultName {
    double obj=0;
    if(defaultName){
        obj=[self guard_doubleForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (NSInteger)guard_integerForKey:(NSString *)defaultName {
    NSInteger obj=0;
    if(defaultName){
        obj=[self guard_integerForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

- (BOOL)guard_boolForKey:(NSString *)defaultName {
    BOOL obj=NO;
    if(defaultName){
        obj=[self guard_boolForKey:defaultName];
    }else{
        NSString *reason=[NSString stringWithFormat:@"NSUserDefaults %@ key can`t be nil",NSStringFromSelector(_cmd)];
        NSException *exception=[NSException exceptionWithName:reason reason:reason userInfo:nil];
        mkHandleCrashException(exception);
    }
    return obj;
}

@end
