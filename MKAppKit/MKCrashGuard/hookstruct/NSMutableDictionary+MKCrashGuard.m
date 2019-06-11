/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableDictionary+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSMutableDictionary_MKCrashGuard)
@implementation NSMutableDictionary (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(guardSetObject:forKey:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(guardRemoveObjectForKey:));
    mk_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(guardSetObject:forKeyedSubscript:));
}

- (void) guardSetObject:(id)object forKey:(id)key {
    if (object && key) {
        [self guardSetObject:object forKey:key];
    } else {
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableDictionary setObject: forKey: ] invalid object:%@ and key:%@  dict:%@",object,key,self]);
    }
}

- (void) guardRemoveObjectForKey:(id)key {
    if (key) {
        [self guardRemoveObjectForKey:key];
    } else {
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableDictionary removeObjectForKey: ] nil key  dict:%@",self]);
    }
}

- (void) guardSetObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        [self guardSetObject:object forKeyedSubscript:key];
    } else {
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableDictionary setObject: forKeyedSubscript: ] object:%@ and forKeyedSubscript:%@  dict:%@",object,key,self]);
    }
}

 
@end
