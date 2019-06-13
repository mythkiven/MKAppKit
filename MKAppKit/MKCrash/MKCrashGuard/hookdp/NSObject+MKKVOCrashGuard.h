/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/09.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MKKVOCrashGuard)

/**
 * 防护：添加监听后没有清除、清除不存在的key、添加重复的key 3 种情况导致的 crash 
 */
+ (void)guardKVOCrash;

- (void)mk_cleanKVO;

@end

NS_ASSUME_NONNULL_END
