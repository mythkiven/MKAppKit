/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableArray+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSMutableArray_MKCrashGuard)
@implementation NSMutableArray (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    
    Class __NSArrayM = NSClassFromString(@"__NSArrayM");
//    Class __NSCFArray = NSClassFromString(@"__NSCFArray");
    
    mk_swizzleInstanceMethod(__NSArrayM, @selector(objectAtIndex:), @selector(_guardObjectAtIndex:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(subarrayWithRange:), @selector(guardSubarrayWithRange:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(objectAtIndexedSubscript:), @selector(guardObjectAtIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(addObject:), @selector(guardAddObject:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(insertObject:atIndex:), @selector(guardInsertObject:atIndex:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(removeObjectAtIndex:), @selector(guardRemoveObjectAtIndex:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(replaceObjectAtIndex:withObject:), @selector(guardReplaceObjectAtIndex:withObject:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(setObject:atIndexedSubscript:), @selector(guardSetObject:atIndexedSubscript:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(removeObjectsInRange:), @selector(guardRemoveObjectsInRange:));
    mk_swizzleInstanceMethod(__NSArrayM, @selector(getObjects:range:), @selector(guardGetObjects:range:));
    
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(objectAtIndex:), @selector(_guardObjectAtIndex:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(subarrayWithRange:), @selector(guardSubarrayWithRange:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(objectAtIndexedSubscript:), @selector(guardObjectAtIndexedSubscript:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(addObject:), @selector(guardAddObject:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(insertObject:atIndex:), @selector(guardInsertObject:atIndex:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(removeObjectAtIndex:), @selector(guardRemoveObjectAtIndex:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(replaceObjectAtIndex:withObject:), @selector(guardReplaceObjectAtIndex:withObject:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(removeObjectsInRange:), @selector(guardRemoveObjectsInRange:));
//    mk_swizzleInstanceMethod(__NSCFArray, @selector(getObjects:range:), @selector(guardGetObjects:range:));
    
}


- (void)guardAddObject:(id)anObject {
    if (anObject) {
        [self guardAddObject:anObject];
    }else{
        mkHandleCrashException(@"[NSMutableArray addObject: ] nil object");
    }
}
- (id)_guardObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self _guardObjectAtIndex:index];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray objectAtIndex: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
    
}
- (id)guardObjectAtIndexedSubscript:(NSInteger)index {
    if (index < self.count) {
        return [self guardObjectAtIndexedSubscript:index];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray objectAtIndexedSubscript: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
}
- (void)guardInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self guardInsertObject:anObject atIndex:index];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray insertObject: atIndex: ] invalid index:%tu total:%tu insert object:%@",index,self.count,anObject]);
    }
}
- (void)guardRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self guardRemoveObjectAtIndex:index];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray removeObjectAtIndex: ] invalid index:%tu total:%tu",index,self.count]);
    }
}
- (void)guardReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count && anObject) {
        [self guardReplaceObjectAtIndex:index withObject:anObject];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray replaceObjectAtIndex: withObject: ] invalid index:%tu total:%tu replace object:%@",index,self.count,anObject]);
    }
}
- (void)guardSetObject:(id)object atIndexedSubscript:(NSUInteger)index {
    if (index <= self.count && object) {
        [self guardSetObject:object atIndexedSubscript:index];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray setObject: atIndexedSubscript: ] invalid object:%@ atIndexedSubscript:%tu total:%tu",object,index,self.count]);
    }
}
- (void)guardRemoveObjectsInRange:(NSRange)range {
    if (range.location + range.length <= self.count) {
        [self guardRemoveObjectsInRange:range];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray removeObjectsInRange: ] invalid range location:%tu length:%tu",range.location,range.length]);
    }
}
- (NSArray *)guardSubarrayWithRange:(NSRange)range {
    if (range.location + range.length <= self.count){
        return [self guardSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self guardSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSMutableArray subarrayWithRange: ] invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
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
