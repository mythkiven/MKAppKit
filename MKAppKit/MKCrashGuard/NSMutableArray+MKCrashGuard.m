/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableArray+MKCrashGuard.h" 
#import "MKCrashGuardManager.h"

@implementation NSMutableArray (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayMClass = NSClassFromString(@"__NSArrayM");
        //objectAtIndex:
        [MKCrashGuardManager exchangeInstanceMethod:arrayMClass systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(crashGuardObjectAtIndex:)];
        //objectAtIndexedSubscript
        if (MKCrashGuardSystemVersion(11.0)) {
            [MKCrashGuardManager exchangeInstanceMethod:arrayMClass systemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(crashGuardObjectAtIndexedSubscript:)];
        }
        //setObject:atIndexedSubscript:
        [MKCrashGuardManager exchangeInstanceMethod:arrayMClass systemSelector:@selector(setObject:atIndexedSubscript:) swizzledSelector:@selector(crashGuardSetObject:atIndexedSubscript:)];
        //removeObjectAtIndex:
        [MKCrashGuardManager exchangeInstanceMethod:arrayMClass systemSelector:@selector(removeObjectAtIndex:) swizzledSelector:@selector(crashGuardRemoveObjectAtIndex:)];
        //insertObject:atIndex:
        [MKCrashGuardManager exchangeInstanceMethod:arrayMClass systemSelector:@selector(insertObject:atIndex:) swizzledSelector:@selector(crashGuardInsertObject:atIndex:)];
        //getObjects:range:
        [MKCrashGuardManager exchangeInstanceMethod:arrayMClass systemSelector:@selector(getObjects:range:) swizzledSelector:@selector(crashGuardGetObjects:range:)];
    });
}

#pragma mark - get object from array
- (void)crashGuardSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self crashGuardSetObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        [MKCrashGuardManager printErrorInfo:exception describe:MKCrashGuardDefaultIgnore];
    }
    @finally {
    }
}

#pragma mark - removeObjectAtIndex:
- (void)crashGuardRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        [self crashGuardRemoveObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [MKCrashGuardManager printErrorInfo:exception describe:MKCrashGuardDefaultIgnore];
    }
    @finally {
    }
}

#pragma mark - set方法
- (void)crashGuardInsertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self crashGuardInsertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [MKCrashGuardManager printErrorInfo:exception describe:MKCrashGuardDefaultIgnore];
    }
    @finally {
        
    }
}


#pragma mark - objectAtIndex:
- (id)crashGuardObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self crashGuardObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}


#pragma mark - objectAtIndexedSubscript:
- (id)crashGuardObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self crashGuardObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}

#pragma mark - getObjects:range: 
- (void)crashGuardGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self crashGuardGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    } @finally {
    }
}




@end
