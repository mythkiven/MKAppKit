/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableDictionary+MKCrashGuard.h" 
#import "MKCrashGuardManager.h"

@implementation NSMutableDictionary (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        //setObject:forKey:
        [MKCrashGuardManager exchangeInstanceMethod:dictionaryM systemSelector:@selector(setObject:forKey:) swizzledSelector:@selector(crashGuardSetObject:forKey:)];
        //setObject:forKeyedSubscript:
        if (MKCrashGuardSystemVersion(11.0)) {
            [MKCrashGuardManager exchangeInstanceMethod:dictionaryM systemSelector:@selector(setObject:forKeyedSubscript:) swizzledSelector:@selector(crashGuardSetObject:forKeyedSubscript:)];
        }
        //removeObjectForKey:
        Method removeObjectForKey = class_getInstanceMethod(dictionaryM, @selector(removeObjectForKey:));
        Method crashGuardRemoveObjectForKey = class_getInstanceMethod(dictionaryM, @selector(crashGuardRemoveObjectForKey:));
        method_exchangeImplementations(removeObjectForKey, crashGuardRemoveObjectForKey);
    });
}


#pragma mark - setObject:forKey:
- (void)crashGuardSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self crashGuardSetObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [MKCrashGuardManager printErrorInfo:exception describe:MKCrashGuardDefaultIgnore];
    }
    @finally {
    }
}

#pragma mark - setObject:forKeyedSubscript:
- (void)crashGuardSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self crashGuardSetObject:obj forKeyedSubscript:key];
    }
    @catch (NSException *exception) {
        [MKCrashGuardManager printErrorInfo:exception describe:MKCrashGuardDefaultIgnore];
    }
    @finally {
    }
}


#pragma mark - removeObjectForKey:
- (void)crashGuardRemoveObjectForKey:(id)aKey {
    @try {
        [self crashGuardRemoveObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        [MKCrashGuardManager printErrorInfo:exception describe:MKCrashGuardDefaultIgnore];
    }
    @finally {
    }
}
 
@end
