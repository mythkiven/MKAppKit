//
//  NSNumber+MKCrashGuard.m
//  MKAppKit
//
//  Created by apple on 2019/6/14.
//

#import "NSNumber+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>

MK_SYNTH_DUMMY_CLASS(NSNumber_MKSELCrashGuard)
@implementation NSNumber (MKCrashGuard)

+ (void)guardNSNumberCrash {
//    mk_swizzleInstanceMethod([self class],@selector(isEqualToNumber:),@selector(guard_isEqualToNumber:));
//    mk_swizzleInstanceMethod([self class],@selector(compare:),@selector(guard_compare:));
}

//- (BOOL)guard_isEqualToNumber:(NSNumber *)number {
//    if (!number) {
//        NSString *reason = [NSString stringWithFormat:@"[NSNumber %@ ] number can`t be nil",NSStringFromSelector(_cmd)];
//        NSException *exception = [NSException exceptionWithName:reason reason:reason userInfo:nil];
//        mkHandleCrashException(exception);
//        return NO;
//    }
//    return [self guard_isEqualToNumber:number];
//}
//
//- (NSComparisonResult)guard_compare:(NSNumber *)number {
//    if (!number) {
//        NSString *reason = [NSString stringWithFormat:@"[NSNumber %@ ] compare can`t be nil",NSStringFromSelector(_cmd)];
//        NSException *exception = [NSException exceptionWithName:reason reason:reason userInfo:nil];
//        mkHandleCrashException(exception);
//        return NSOrderedAscending;
//    }
//    return [self guard_compare:number];
//}
@end
