/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSObject+MKSELCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>

MK_SYNTH_DUMMY_CLASS(NSObject_MKSELCrashGuard)
@implementation NSObject (MKSELCrashGuard)

+ (void)guardUnrecognizedSelectorCrash { 
    mk_swizzleClassMethod([self class], @selector(methodSignatureForSelector:), @selector(classMethodSignatureForSelectorSwizzled:));
    mk_swizzleClassMethod([self class], @selector(forwardInvocation:), @selector(forwardClassInvocationSwizzled:));
    
    mk_swizzleInstanceMethod([self class], @selector(methodSignatureForSelector:), @selector(methodSignatureForSelectorSwizzled:));
    mk_swizzleInstanceMethod([self class], @selector(forwardInvocation:), @selector(forwardInvocationSwizzled:));
}

+ (NSMethodSignature*)classMethodSignatureForSelectorSwizzled:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self classMethodSignatureForSelectorSwizzled:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}
- (NSMethodSignature*)methodSignatureForSelectorSwizzled:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self methodSignatureForSelectorSwizzled:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

/**
 * Check the class method signature to the [NSObject class]
 * If not equals,return nil
 * If equals,return the v@:@ method
 @param currentClass Class
 @return NSMethodSignature
 */
+ (NSMethodSignature *)checkObjectSignatureAndCurrentClass:(Class)currentClass{
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation(currentClass, @selector(methodSignatureForSelector:));
    // If current class override methodSignatureForSelector return nil
    if (originIMP != currentClassIMP){
        return nil;
    }
    // Customer method signature
    // void xxx(id,sel,id)
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

/**
 Forward instance object
 @param invocation NSInvocation
 */
- (void)forwardInvocationSwizzled:(NSInvocation*)invocation{
    mkHandleCrashException([NSString stringWithFormat:@"forwardInvocationSwizzled: Unrecognized instance class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)]);
}

/**
 Forward class object
 @param invocation NSInvocation
 */
+ (void)forwardClassInvocationSwizzled:(NSInvocation*)invocation{
    mkHandleCrashException([NSString stringWithFormat:@"forwardClassInvocationSwizzled: Unrecognized static class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)]);
}
@end
