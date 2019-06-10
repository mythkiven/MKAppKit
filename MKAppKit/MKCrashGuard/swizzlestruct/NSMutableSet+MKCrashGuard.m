/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "NSMutableSet+MKCrashGuard.h"
#import <objc/runtime.h>
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"


@implementation NSMutableSet (MKCrashGuard)
+ (void)crashGuardExchangeMethod {
    NSMutableSet* instanceObject = [NSMutableSet new];
    Class cls =  object_getClass(instanceObject); 
    mk_swizzleInstanceMethod(cls,@selector(addObject:), @selector(guardAddObject:));
    mk_swizzleInstanceMethod(cls,@selector(removeObject:), @selector(guardRemoveObject:));
}

- (void) guardAddObject:(id)object {
    if (object) {
        [self guardAddObject:object];
    } else {
        mkHandleCrashException(@"NSSet addObject nil object");
    }
}

- (void) guardRemoveObject:(id)object {
    if (object) {
        [self guardRemoveObject:object];
    } else {
        mkHandleCrashException(@"NSSet removeObject nil object");
    }
}

@end
