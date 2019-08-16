/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/16.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSObject+MKGuard.h"

#import <objc/runtime.h>
@interface MKParasite : NSObject
@property (nonatomic, copy) void(^mkDeallocBlock)(void);
@end
@implementation MKParasite
- (void)dealloc {
    if (self.mkDeallocBlock) {
        self.mkDeallocBlock();
    }
}
@end

@implementation NSObject (MKGuard)
- (void)guard_addDeallocBlock:(void(^)(void))block {
    @synchronized (self) {
        static NSString *kAssociatedKey = nil;
        NSMutableArray *parasiteList = objc_getAssociatedObject(self, &kAssociatedKey);
        if (!parasiteList) {
            parasiteList = [NSMutableArray new];
            objc_setAssociatedObject(self, &kAssociatedKey, parasiteList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        MKParasite *parasite = [MKParasite new];
        parasite.mkDeallocBlock = block;
        [parasiteList addObject: parasite];
    }
}
@end
