/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>





NS_ASSUME_NONNULL_BEGIN


typedef void (*MKSwizzleOriginalIMP)(void /* id, SEL, ... */ );
@interface MKSwizzleObject : NSObject
- (MKSwizzleOriginalIMP)getOriginalImplementation;
@property (nonatomic,readonly,assign) SEL selector;
@end




typedef id (^MKSwizzledIMPBlock)(MKSwizzleObject* swizzleInfo);
static void mk_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector);
static void mk_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector);
void mk_swizzleDeallocIfNeeded(Class class);


@interface NSObject (MKSwizzleHook)
+ (void)mk_swizzleClassMethod:(SEL)systemSelector withSwizzleMethod:(SEL)swizzleSelector;
- (void)mk_swizzleInstanceMethod:(SEL)systemSelector withSwizzleMethod:(SEL)swizzleSelector;
- (void)mk_swizzleInstanceMethod:(SEL)systemSelector withSwizzledBlock:(MKSwizzledIMPBlock)swizzledBlock;
@end

NS_ASSUME_NONNULL_END
