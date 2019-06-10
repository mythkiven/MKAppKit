/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSObject+MKKVOCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>
#import <objc/message.h>


static const char mkDeallocKVOKey;
static const char mkObserverDeallocKVOKey;

/**
 Record the kvo object Override the isEqual and hash method
 */
@interface KVOObjectItem : NSObject
@property(nonatomic,readwrite,assign)NSObject* observer;
@property(nonatomic,readwrite,copy)NSString* keyPath;
@property(nonatomic,readwrite,assign)NSKeyValueObservingOptions options;
@property(nonatomic,readwrite,assign)void* context;
@end
@implementation KVOObjectItem
- (BOOL)isEqual:(KVOObjectItem*)object {
    if ([self.observer isEqual:object.observer] && [self.keyPath isEqualToString:object.keyPath]) {
        return YES;
    }
    return NO;
}
- (NSUInteger)hash {
    return [self.observer hash] ^ [self.keyPath hash];
}
- (void)dealloc {
    self.observer = nil;
    self.context = nil;
}
@end


#pragma mark -
#pragma mark -

@interface KVOObjectContainer : NSObject
/**
 KVO object array set
 */
@property(nonatomic,readwrite,retain)NSMutableSet* kvoObjectSet;
/**
 Associated owner object
 */
@property(nonatomic,readwrite,unsafe_unretained)NSObject* whichObject;
/**
 NSMutableSet safe-thread
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property(nonatomic,readwrite,retain)dispatch_semaphore_t kvoLock;
#else
@property(nonatomic,readwrite,assign)dispatch_semaphore_t kvoLock;
#endif
- (void)addKVOObjectItem:(KVOObjectItem*)item;
- (void)removeKVOObjectItem:(KVOObjectItem*)item;
- (BOOL)checkKVOItemExist:(KVOObjectItem*)item;
@end
@implementation KVOObjectContainer
- (void)addKVOObjectItem:(KVOObjectItem*)item {
    if (item) {
        dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
        [self.kvoObjectSet addObject:item];
        dispatch_semaphore_signal(self.kvoLock);
    }
}
- (void)removeKVOObjectItem:(KVOObjectItem*)item {
    if (item) {
        dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
        [self.kvoObjectSet removeObject:item];
        dispatch_semaphore_signal(self.kvoLock);
    }
}
- (BOOL)checkKVOItemExist:(KVOObjectItem*)item {
    dispatch_semaphore_wait(self.kvoLock, DISPATCH_TIME_FOREVER);
    BOOL exist = NO;
    if (!item) {
        dispatch_semaphore_signal(self.kvoLock);
        return exist;
    }
    exist = [self.kvoObjectSet containsObject:item];
    dispatch_semaphore_signal(self.kvoLock);
    return exist;
}

- (dispatch_semaphore_t)kvoLock {
    if (!_kvoLock) {
        _kvoLock = dispatch_semaphore_create(1);
        return _kvoLock;
    }
    return _kvoLock;
}
/**
 Clean the kvo object array and temp var
 release the dispatch_semaphore
 */
- (void)dealloc {
    self.whichObject = nil;
    self.kvoLock = NULL;
}
- (void)cleanKVOData{
    for (KVOObjectItem* item in self.kvoObjectSet) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        @try {
            ((void(*)(id,SEL,id,NSString*))objc_msgSend)(self.whichObject,@selector(guardRemoveObserver:forKeyPath:),item.observer,item.keyPath);
        }@catch (NSException *exception) {
        }
#pragma clang diagnostic pop
    }
}
- (NSMutableSet*)kvoObjectSet{
    if(_kvoObjectSet){
        return _kvoObjectSet;
    }
    _kvoObjectSet = [[NSMutableSet alloc] init];
    return _kvoObjectSet;
}
@end

#pragma mark -
#pragma mark -

@interface JJObserverContainer : NSObject
@property (nonatomic,readwrite,retain) NSHashTable* observers;
/**
 Associated owner object
 */
@property(nonatomic,readwrite,assign) NSObject* whichObject;
- (void)addObserver:(KVOObjectItem *)observer;
- (void)removeObserver:(KVOObjectItem *)observer;
@end

@implementation JJObserverContainer
- (instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [NSHashTable hashTableWithOptions:NSMapTableWeakMemory];
    }
    return self;
}

- (void)addObserver:(KVOObjectItem *)observer {
    @synchronized (self) {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(KVOObjectItem *)observer {
    @synchronized (self) {
        [self.observers removeObject:observer];
    }
}

- (void)cleanObservers {
    for (KVOObjectItem* item in self.observers) {
        [self.whichObject removeObserver:item.observer forKeyPath:item.keyPath];
        
    }
    @synchronized (self) {
        [self.observers removeAllObjects];
    }
}

- (void)dealloc {
    self.whichObject = nil;
}

@end


#pragma mark -
#pragma mark -

MK_SYNTH_DUMMY_CLASS(NSObject_MKKVOCrashGuard)
@implementation NSObject (MKKVOCrashGuard) 

+ (void)guardKVOCrash{
    mk_swizzleInstanceMethod([self class], @selector(addObserver:forKeyPath:options:context:), @selector(guardAddObserver:forKeyPath:options:context:));
    mk_swizzleInstanceMethod([self class], @selector(removeObserver:forKeyPath:), @selector(guardRemoveObserver:forKeyPath:));
    mk_swizzleInstanceMethod([self class], @selector(removeObserver:forKeyPath:context:), @selector(guardRemoveObserver:forKeyPath:context:));
}

- (void)guardAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    if ([self ignoreKVOInstanceClass:observer]) {
        [self guardAddObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    
    if (!observer || keyPath.length == 0) {
        return;
    }
    
    mkHandleCrashException([NSString stringWithFormat:@"[NSObject addObserver:forKeyPath:options:context: ] invalid observer:%@ or keyPath:%@",observer,keyPath]);
    
    KVOObjectContainer* objectContainer = objc_getAssociatedObject(self,&mkDeallocKVOKey);
    
    KVOObjectItem* item = [[KVOObjectItem alloc] init];
    item.observer = observer;
    item.keyPath = keyPath;
    item.options = options;
    item.context = context;
    
    if (!objectContainer) {
        objectContainer = [KVOObjectContainer new];
        [objectContainer setWhichObject:self];
        objc_setAssociatedObject(self, &mkDeallocKVOKey, objectContainer, OBJC_ASSOCIATION_RETAIN);
    }
    
    if (![objectContainer checkKVOItemExist:item]) {
        [objectContainer addKVOObjectItem:item];
        [self guardAddObserver:observer forKeyPath:keyPath options:options context:context];
    }
    
    JJObserverContainer* observerContainer = objc_getAssociatedObject(observer,&mkObserverDeallocKVOKey);
    
    if (!observerContainer) {
        observerContainer = [JJObserverContainer new];
        [observerContainer setWhichObject:self];
        [observerContainer addObserver:item];
        objc_setAssociatedObject(observer, &mkObserverDeallocKVOKey, observerContainer, OBJC_ASSOCIATION_RETAIN);
    }else{
        [observerContainer addObserver:item];
    }
    
    mk_swizzleDeallocIfNeeded(self.class);
    mk_swizzleDeallocIfNeeded(observer.class);
}

- (void)guardRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void*)context{
    if ([self ignoreKVOInstanceClass:observer]) {
        [self guardRemoveObserver:observer forKeyPath:keyPath context:context];
        return;
    }
    mkHandleCrashException([NSString stringWithFormat:@"[NSObject removeObserver:forKeyPath:context:] invalid observer:%@ or keyPath:%@ context:%@",observer,keyPath,context]);
    [self removeObserver:observer forKeyPath:keyPath];
}

- (void)guardRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if ([self ignoreKVOInstanceClass:observer]) {
        [self guardRemoveObserver:observer forKeyPath:keyPath];
        return;
    }
    
    KVOObjectContainer* objectContainer = objc_getAssociatedObject(self, &mkDeallocKVOKey);
    
    if (!observer) {
        return;
    }
    if (!objectContainer) {
        return;
    }
    
    mkHandleCrashException([NSString stringWithFormat:@"[NSObject addObserver:forKeyPath:options:context: ] invalid observer:%@ or keyPath:%@",observer,keyPath]);
    
    KVOObjectItem* item = [[KVOObjectItem alloc] init];
    item.observer = observer;
    item.keyPath = keyPath;
    
    if ([objectContainer checkKVOItemExist:item]) {
        @try {
            [self guardRemoveObserver:observer forKeyPath:keyPath];
        }@catch (NSException *exception) {
        }
        [objectContainer removeKVOObjectItem:item];
    }
}

/**
 Ignore Special Library
 
 @param object Instance Class
 @return YES or NO
 */
- (BOOL)ignoreKVOInstanceClass:(id)object {
    if (!object) {
        return NO;
    }
    //Ignore ReactiveCocoa
    if (object_getClass(object) == objc_getClass("RACKVOProxy")) {
        return YES;
    }
    //Ignore AMAP
    NSString* className = NSStringFromClass(object_getClass(object));
    if ([className hasPrefix:@"AMap"]) {
        return YES;
    }
    return NO;
}


/**
 * guard the kvo object dealloc and to clean the kvo array
 */
- (void)mk_cleanKVO {
    KVOObjectContainer* objectContainer = objc_getAssociatedObject(self, &mkDeallocKVOKey);
    JJObserverContainer* observerContainer = objc_getAssociatedObject(self, &mkObserverDeallocKVOKey);
    if (objectContainer) {
        [objectContainer cleanKVOData];
    }else if(observerContainer){
        [observerContainer cleanObservers];
    }
}

@end

