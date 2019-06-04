/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSArray+MKCrashGuard.h" 
#import "MKCrashGuardManager.h"

MK_SYNTH_DUMMY_CLASS(NSArray_MKCrashGuard)
@implementation NSArray (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // instance array method exchange
        [MKCrashGuardManager exchangeClassMethod:[self class] systemSelector:@selector(arrayWithObjects:count:) swizzledSelector:@selector(MKCrashGuardArrayWithObjects:count:)];
        
        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        
        //objectsAtIndexes:
        [MKCrashGuardManager exchangeInstanceMethod:__NSArray systemSelector:@selector(objectsAtIndexes:) swizzledSelector:@selector(crashGuardObjectsAtIndexes:)];
        
        
        
        //objectAtIndex:
        [MKCrashGuardManager exchangeInstanceMethod:__NSArrayI systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(__NSArrayIMKCrashGuardObjectAtIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:__NSSingleObjectArrayI systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(__NSSingleObjectArrayIMKCrashGuardObjectAtIndex:)];
        [MKCrashGuardManager exchangeInstanceMethod:__NSArray0 systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(__NSArray0MKCrashGuardObjectAtIndex:)];
        
        
        
        //objectAtIndexedSubscript:
        if (MKCrashGuardSystemVersion(11.0)) {
            [MKCrashGuardManager exchangeInstanceMethod:__NSArrayI systemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(__NSArrayIMKCrashGuardObjectAtIndexedSubscript:)];
        }
        
        
        
        //getObjects:range:
        [MKCrashGuardManager exchangeInstanceMethod:__NSArray systemSelector:@selector(getObjects:range:) swizzledSelector:@selector(NSArrayMKCrashGuardGetObjects:range:)];
        [MKCrashGuardManager exchangeInstanceMethod:__NSSingleObjectArrayI systemSelector:@selector(getObjects:range:) swizzledSelector:@selector(__NSSingleObjectArrayIMKCrashGuardGetObjects:range:)];
        [MKCrashGuardManager exchangeInstanceMethod:__NSArrayI systemSelector:@selector(getObjects:range:) swizzledSelector:@selector(__NSArrayIMKCrashGuardGetObjects:range:)];
    });
}

#pragma mark - instance array
+ (instancetype)MKCrashGuardArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self MKCrashGuardArrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        NSString *description = @"MKCrashGuard default is to remove nil object and instance a array.";
        [MKCrashGuardManager printErrorInfo:exception describe:description];
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self MKCrashGuardArrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

#pragma mark  - objectAtIndexedSubscript:
- (id)__NSArrayIMKCrashGuardObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self __NSArrayIMKCrashGuardObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}

#pragma mark - objectsAtIndexes:
- (NSArray *)crashGuardObjectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self crashGuardObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    } @finally {
        return returnArray;
    }
}

#pragma mark - objectAtIndex:
- (id)__NSArrayIMKCrashGuardObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self __NSArrayIMKCrashGuardObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}
- (id)__NSSingleObjectArrayIMKCrashGuardObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self __NSSingleObjectArrayIMKCrashGuardObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultReturnNil;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    }
    @finally {
        return object;
    }
}
- (id)__NSArray0MKCrashGuardObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self __NSArray0MKCrashGuardObjectAtIndex:index];
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
- (void)NSArrayMKCrashGuardGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self NSArrayMKCrashGuardGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    } @finally {
    }
}
- (void)__NSSingleObjectArrayIMKCrashGuardGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self __NSSingleObjectArrayIMKCrashGuardGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    } @finally {
    }
}
- (void)__NSArrayIMKCrashGuardGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self __NSArrayIMKCrashGuardGetObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *description = MKCrashGuardDefaultIgnore;
        [MKCrashGuardManager printErrorInfo:exception describe:description];
    } @finally {
    }
}
 

@end
