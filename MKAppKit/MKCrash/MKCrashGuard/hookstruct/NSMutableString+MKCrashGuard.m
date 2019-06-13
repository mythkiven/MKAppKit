/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSMutableString+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"

MK_SYNTH_DUMMY_CLASS(NSMutableString_MKCrashGuard)
@implementation NSMutableString (MKCrashGuard)

#pragma mark   MKCrashGuardProtocol
+ (void)crashGuardExchangeMethod {
    Class stringClass = NSClassFromString(@"__NSCFString");
    mk_swizzleInstanceMethod(stringClass, @selector(appendString:), @selector(guardAppendString:));
    mk_swizzleInstanceMethod(stringClass, @selector(insertString:atIndex:), @selector(guardInsertString:atIndex:));
    mk_swizzleInstanceMethod(stringClass, @selector(deleteCharactersInRange:), @selector(guardDeleteCharactersInRange:));
    mk_swizzleInstanceMethod(stringClass, @selector(substringFromIndex:), @selector(guardSubstringFromIndex:));
    mk_swizzleInstanceMethod(stringClass, @selector(substringToIndex:), @selector(guardSubstringToIndex:));
    mk_swizzleInstanceMethod(stringClass, @selector(substringWithRange:), @selector(guardSubstringWithRange:));
    mk_swizzleInstanceMethod(stringClass, @selector(replaceCharactersInRange:withString:), @selector(guardReplaceCharactersInRange:withString:));
    
}

- (void) guardAppendString:(NSString *)aString {
    if (aString){
        [self guardAppendString:aString];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableString appendString: ] value:%@ parameter nil",self]);
    }
}
- (void) guardInsertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (aString && loc <= self.length) {
        [self guardInsertString:aString atIndex:loc];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableString insertString: atIndex: ] value:%@ paremeter string:%@ atIndex:%tu",self,aString,loc]);
    }
}
- (void) guardDeleteCharactersInRange:(NSRange)range {
    if (range.location + range.length <= self.length){
        [self guardDeleteCharactersInRange:range];
    }else{
        mkHandleCrashException([NSString stringWithFormat:@"[NSMutableString deleteCharactersInRange: ] value:%@ range:%@",self,NSStringFromRange(range)]);
    }
}
- (NSString *)guardSubstringFromIndex:(NSUInteger)from {
    if (from <= self.length) {
        return [self guardSubstringFromIndex:from];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSMutableString substringFromIndex: ] value:%@ from:%tu",self,from]);
    return nil;
}
- (NSString *)guardSubstringToIndex:(NSUInteger)to {
    if (to <= self.length) {
        return [self guardSubstringToIndex:to];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSMutableString substringToIndex: ] value:%@ to:%tu",self,to]);
    return self;
}
- (NSString *)guardSubstringWithRange:(NSRange)range {
    if (range.location + range.length <= self.length){
        return [self guardSubstringWithRange:range];
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSMutableString substringWithRange: ] value:%@ range:%@",self,NSStringFromRange(range)]);
    return nil;
} 
- (void)guardReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self guardReplaceCharactersInRange:range withString:aString];
    }
    @catch (NSException *exception) {
        mkHandleCrashException(exception);
    }
    @finally {
    }
}








@end
