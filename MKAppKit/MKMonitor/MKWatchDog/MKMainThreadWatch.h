/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/24.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMainThreadWatch : NSObject

- (instancetype)initWithThreshold:(double)threshold strictMode:(BOOL)strictMode;

@end


NS_ASSUME_NONNULL_END
