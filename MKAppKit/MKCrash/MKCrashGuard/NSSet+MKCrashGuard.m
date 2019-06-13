/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSSet+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"


@implementation NSSet (MKCrashGuard)
+ (void)crashGuardExchangeMethod {
    [NSSet mk_swizzleClassMethod:@selector(setWithObject:) withSwizzleMethod:@selector(guardSetWithObject:)];
}

+ (instancetype)guardSetWithObject:(id)object {
    if (object){
        return [self guardSetWithObject:object];
    }
    mkHandleCrashException(@"NSSet setWithObject nil object");
    return nil;
}


@end
