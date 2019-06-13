/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>

typedef IMP (^MKSwizzleHookImpProvider)(void);
static const void *mkKVODeallocAssociatedKey = &mkKVODeallocAssociatedKey;

@interface MKSwizzleObject()
@property (nonatomic,readwrite,copy) MKSwizzleHookImpProvider impProviderBlock;
@property (nonatomic,readwrite,assign) SEL selector;
@end
@implementation MKSwizzleObject
- (MKSwizzleOriginalIMP)getOriginalImplementation{
    NSAssert(_impProviderBlock,nil);
    return (MKSwizzleOriginalIMP)_impProviderBlock();
}
@end


#pragma mark -
#pragma mark -

static const void *mkNSObjectDeallocAssociatedKey = &mkNSObjectDeallocAssociatedKey;

@interface MKDeallocExecutor : NSObject

@property (nonatomic,readwrite,copy) void(^deallocBlock)(void);

@end

@implementation MKDeallocExecutor

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
    self.deallocBlock = nil;
}

@end
 

#pragma mark -
#pragma mark - C type

void mk_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
    if (!cls) {
        return;
    }
    Method originalMethod = class_getClassMethod(cls, originSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzleSelector);
    NSCAssert(NULL != originalMethod,
               @"originSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(originSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
    NSCAssert(NULL != swizzledMethod,
               @"swizzleSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(swizzleSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        class_replaceMethod(metacls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        class_replaceMethod(metacls,
                            swizzleSelector,
                            class_replaceMethod(metacls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

void mk_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
    if (!cls) {
        return;
    }
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzleSelector);
     
    NSCAssert(NULL != originalMethod,
               @"originSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(originSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
    NSCAssert(NULL != swizzledMethod,
               @"swizzleSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(swizzleSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
     
    if (class_addMethod(cls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        class_replaceMethod(cls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        class_replaceMethod(cls,
                            swizzleSelector,
                            class_replaceMethod(cls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}
// a class doesn't need dealloc swizzled if it or a superclass has been swizzled already
BOOL mk_requiresDeallocSwizzle(Class class) {
    BOOL swizzled = NO;
    for ( Class currentClass = class; !swizzled && currentClass != nil; currentClass = class_getSuperclass(currentClass) ) {
        swizzled = [objc_getAssociatedObject(currentClass, mkKVODeallocAssociatedKey) boolValue];
    }
    return !swizzled;
}

void mk_swizzleKVODeallocIfNeeded(Class class) {
    static SEL deallocSEL = NULL;
    static SEL cleanupSEL = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deallocSEL = sel_getUid("dealloc");
        cleanupSEL = sel_getUid("mk_cleanKVO");
    });
    @synchronized (class) {
        if ( !mk_requiresDeallocSwizzle(class) ) {
            return;
        }
        objc_setAssociatedObject(class, mkKVODeallocAssociatedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    Method dealloc = NULL;
    unsigned int count = 0;
    Method* method = class_copyMethodList(class, &count);
    for (unsigned int i = 0; i < count; i++) {
        if (method_getName(method[i]) == deallocSEL) {
            dealloc = method[i];
            break;
        }
    }
    if ( dealloc == NULL ) {
        Class superclass = class_getSuperclass(class);
        class_addMethod(class, deallocSEL, imp_implementationWithBlock(^(__unsafe_unretained id self) {
            ((void(*)(id, SEL))objc_msgSend)(self, cleanupSEL);
            struct objc_super superStruct = (struct objc_super){ self, superclass };
            ((void (*)(struct objc_super*, SEL))objc_msgSendSuper)(&superStruct, deallocSEL);
        }), method_getTypeEncoding(dealloc));
    }else{
        __block IMP deallocIMP = method_setImplementation(dealloc, imp_implementationWithBlock(^(__unsafe_unretained id self) {
            ((void(*)(id, SEL))objc_msgSend)(self, cleanupSEL);
            ((void(*)(id, SEL))deallocIMP)(self, deallocSEL);
        }));
    }
}


#pragma mark -
#pragma mark - MKSwizzleHook

@implementation NSObject (MKSwizzleHook)

void __MK_SWIZZLE_BLOCK(Class classToSwizzle,SEL selector,MKSwizzledIMPBlock impBlock) {
    Method method = class_getInstanceMethod(classToSwizzle, selector);
    __block IMP originalIMP = NULL;
    MKSwizzleHookImpProvider originalImpProvider = ^IMP{
        IMP imp = originalIMP;
        if (NULL == imp){
            Class superclass = class_getSuperclass(classToSwizzle);
            imp = method_getImplementation(class_getInstanceMethod(superclass,selector));
        }
        return imp;
    };
    MKSwizzleObject* swizzleInfo = [MKSwizzleObject new];
    swizzleInfo.selector = selector;
    swizzleInfo.impProviderBlock = originalImpProvider;
    id newIMPBlock = impBlock(swizzleInfo);
    const char* methodType = method_getTypeEncoding(method);
    IMP newIMP = imp_implementationWithBlock(newIMPBlock);
    originalIMP = class_replaceMethod(classToSwizzle, selector, newIMP, methodType);
}

+ (void)mk_swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector {
    mk_swizzleClassMethod(self.class, originSelector, swizzleSelector);
}

- (void)mk_swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector {
    mk_swizzleInstanceMethod(self.class, originSelector, swizzleSelector);
}

- (void)mk_swizzleInstanceMethod:(SEL)originSelector withSwizzledBlock:(MKSwizzledIMPBlock)swizzledBlock {
    __MK_SWIZZLE_BLOCK(self.class, originSelector, swizzledBlock);
}

/**
 在当前对象销毁时调用
 @param block 销毁时调用的 block
 */
- (void)mk_runAtDealloc:(void(^)(void))block {
    @synchronized(self) {
        NSMutableArray* blockArray = objc_getAssociatedObject(self, mkNSObjectDeallocAssociatedKey);
        if (!blockArray) {
            blockArray = [NSMutableArray array];
            objc_setAssociatedObject(self, mkNSObjectDeallocAssociatedKey, blockArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        MKDeallocExecutor *stub = [MKDeallocExecutor new];
        stub.deallocBlock = block;
        [blockArray addObject:stub];
    }
}


@end
