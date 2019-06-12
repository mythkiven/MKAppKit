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
    mk_swizzleClassMethod([self class], @selector(methodSignatureForSelector:), @selector(mk_classMethodSignatureForSelector:));
    mk_swizzleClassMethod([self class], @selector(forwardInvocation:), @selector(mk_forwardClassInvocation:));
    
    mk_swizzleInstanceMethod([self class], @selector(methodSignatureForSelector:), @selector(mk_methodSignatureForSelector:));
    mk_swizzleInstanceMethod([self class], @selector(forwardInvocation:), @selector(mk_forwardInvocation:));
}


+ (NSMethodSignature*)mk_classMethodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self mk_classMethodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

+ (void)mk_forwardClassInvocation:(NSInvocation*)invocation {
    mkHandleCrashException([NSString stringWithFormat:@"forwardInvocation: Unrecognized static class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)]);
}


- (NSMethodSignature*)mk_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self mk_methodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

- (void)mk_forwardInvocation:(NSInvocation*)invocation {
    mkHandleCrashException([NSString stringWithFormat:@"forwardInvocation: Unrecognized instance class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)]);
}


+ (NSMethodSignature *)checkObjectSignatureAndCurrentClass:(Class)currentClass {
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation(currentClass, @selector(methodSignatureForSelector:));
    
    // 已重写
    if (originIMP != currentClassIMP){
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}




@end
