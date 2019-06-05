/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSDictionary+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSDictionary_MKCrashGuard)
@implementation NSDictionary (MKCrashGuard)


#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    [NSDictionary mk_swizzleClassMethod:@selector(dictionaryWithObject:forKey:) withSwizzleMethod:@selector(guardDictionaryWithObject:forKey:)];
    [NSDictionary mk_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withSwizzleMethod:@selector(guardDictionaryWithObjects:forKeys:count:)];
}

+ (instancetype)guardDictionaryWithObject:(id)object forKey:(id)key {
    if (object && key) {
        return [self guardDictionaryWithObject:object forKey:key];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSDictionary dictionaryWithObject: ] invalid object:%@ and key:%@",object,key]);
    return nil;
}
+ (instancetype)guardDictionaryWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt {
    NSInteger index = 0;
    id ks[cnt];
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (keys[i] && objects[i]) {
            ks[index] = keys[i];
            objs[index] = objects[i];
            ++index;
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"[NSDictionary dictionaryWithObjects: count: ] invalid keys:%@ and object:%@",keys[i],objects[i]]);
        }
    }
    return [self guardDictionaryWithObjects:objs forKeys:ks count:index];
}

@end
