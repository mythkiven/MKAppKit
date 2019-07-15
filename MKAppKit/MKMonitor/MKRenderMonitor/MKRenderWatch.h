/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRenderWatch : NSObject

/**
 开始Render监控

 @param pathToSaveLog 保存render日志的绝对路径，路径不正确将使用默认路径，为nil则不保存
 */
-(void)watchRenderWithLogPath:(nullable NSString*)pathToSaveLog;
@end

NS_ASSUME_NONNULL_END
