/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSDictionary+MKCrashGuard.h" 
#import "MKCrashGuardManager.h"

@implementation NSDictionary (MKCrashGuard)


#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MKCrashGuardManager exchangeClassMethod:self systemSelector:@selector(dictionaryWithObjects:forKeys:count:) swizzledSelector:@selector(crashGuardDictionaryWithObjects:forKeys:count:)];
    });
} 

+ (instancetype)crashGuardDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt { 
    id instance = nil;
    @try {
        instance = [self crashGuardDictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        NSString *description = @"MKCrashGuard default is to remove nil key-values and instance a dictionary.";
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self crashGuardDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

@end
