/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/16.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MKGuard)
/**
 @brief 添加一个block,当该对象释放时被调用
 **/
- (void)guard_addDeallocBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
