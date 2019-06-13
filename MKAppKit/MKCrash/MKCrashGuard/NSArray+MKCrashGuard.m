/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSArray+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSArray_MKCrashGuard)

@implementation NSArray (MKCrashGuard)

#pragma mark  -  MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    
    [NSArray mk_swizzleClassMethod:@selector(arrayWithObject:) withSwizzleMethod:@selector(guardArrayWithObject:)];
    [NSArray mk_swizzleClassMethod:@selector(arrayWithObjects:count:) withSwizzleMethod:@selector(guardArrayWithObjects:count:)];
    
//    Class __NSArray = NSClassFromString(@"NSArray");
    Class __NSArray0 = NSClassFromString(@"__NSArray0");
    Class __NSArrayI = NSClassFromString(@"__NSArrayI");
    Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
    Class __NSArrayI_Transfer = NSClassFromString(@"__NSArrayI_Transfer");
    Class __NSFrozenArrayM = NSClassFromString(@"__NSFrozenArrayM");
    Class __NSArrayReversed = NSClassFromString(@"__NSArrayReversed");
    
    
//    mk_swizzleInstanceMethod(__NSArray,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
//    mk_swizzleInstanceMethod(__NSArray,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
//    mk_swizzleInstanceMethod(__NSArray,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
//    mk_swizzleInstanceMethod(__NSArray,@selector(getObjects:range:),@selector(guardGetObjects:range:));
//    mk_swizzleInstanceMethod(__NSArray,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));
    
    mk_swizzleInstanceMethod(__NSArray0,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
    mk_swizzleInstanceMethod(__NSArray0,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
    if(@available(iOS 11.0, *))
        mk_swizzleInstanceMethod(__NSArray0,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSArray0,@selector(getObjects:range:),@selector(guardGetObjects:range:));
    mk_swizzleInstanceMethod(__NSArray0,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));
    
    mk_swizzleInstanceMethod(__NSArrayI,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
    mk_swizzleInstanceMethod(__NSArrayI,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
    if(@available(iOS 11.0, *))
        mk_swizzleInstanceMethod(__NSArrayI,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSArrayI,@selector(getObjects:range:),@selector(guardGetObjects:range:));
    mk_swizzleInstanceMethod(__NSArrayI,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));
    
    mk_swizzleInstanceMethod(__NSSingleObjectArrayI,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
    mk_swizzleInstanceMethod(__NSSingleObjectArrayI,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
    if(@available(iOS 11.0, *))
        mk_swizzleInstanceMethod(__NSSingleObjectArrayI,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSSingleObjectArrayI,@selector(getObjects:range:),@selector(guardGetObjects:range:));
    mk_swizzleInstanceMethod(__NSSingleObjectArrayI,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));

    mk_swizzleInstanceMethod(__NSArrayI_Transfer,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
    mk_swizzleInstanceMethod(__NSArrayI_Transfer,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
    if(@available(iOS 11.0, *))
        mk_swizzleInstanceMethod(__NSArrayI_Transfer,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSArrayI_Transfer,@selector(getObjects:range:),@selector(guardGetObjects:range:));
    mk_swizzleInstanceMethod(__NSArrayI_Transfer,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));

    mk_swizzleInstanceMethod(__NSFrozenArrayM,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
    mk_swizzleInstanceMethod(__NSFrozenArrayM,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
    if(@available(iOS 11.0, *))
        mk_swizzleInstanceMethod(__NSFrozenArrayM,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSFrozenArrayM,@selector(getObjects:range:),@selector(guardGetObjects:range:));
    mk_swizzleInstanceMethod(__NSFrozenArrayM,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));

    mk_swizzleInstanceMethod(__NSArrayReversed,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
    mk_swizzleInstanceMethod(__NSArrayReversed,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
    if(@available(iOS 11.0, *))
        mk_swizzleInstanceMethod(__NSArrayReversed,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSArrayReversed,@selector(getObjects:range:),@selector(guardGetObjects:range:));
    mk_swizzleInstanceMethod(__NSArrayReversed,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));
    
}

#pragma mark - hook class
+ (instancetype) guardArrayWithObject:(id)anObject {
    if (anObject) {
        return [self guardArrayWithObject:anObject];
    }
    mkHandleCrashException(@"[NSArray arrayWithObject:] object is nil");
    return nil;
}
+ (instancetype)guardArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    NSInteger index = 0;
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (objects[i]) {
            objs[index++] = objects[i];
        }else{
            mkHandleCrashException([NSString stringWithFormat:@"[NSArray arrayWithObjects: count: ] invalid index object:%tu total:%tu",i,cnt]);
        }
    }
    return [self guardArrayWithObjects:objs count:index];
}

#pragma mark - hook instance
- (NSArray *)guardSubarrayWithRange:(NSRange)range {
    if (range.location + range.length <= self.count){
        return [self guardSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self guardSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSArray subarrayWithRange: ] invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
}
- (id)guardObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) {
        return [self guardObjectAtIndexedSubscript:idx];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSArray objectAtIndexedSubscript: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
}
- (id)guardObjectAtIndex:(NSUInteger)index {
    if (index < self.count) { 
        return [self guardObjectAtIndex:index];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSArray objectAtIndex: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
    
}

- (NSArray *)guardObjectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self guardObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        mkHandleCrashException(exception);
    } @finally {
        return returnArray;
    }
}
- (void)guardGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self guardGetObjects:objects range:range];
    } @catch (NSException *exception) {
        mkHandleCrashException(exception);
    } @finally {
    }
}
 

@end
