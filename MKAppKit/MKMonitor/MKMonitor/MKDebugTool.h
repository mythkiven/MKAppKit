/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNotifyKeyReloadHttp    @"kNotifyKeyReloadHttp"


@protocol MKDebugDelegate <NSObject>
- (NSData*)decryptJson:(NSData*)data;
@end

@interface MKDebugTool : NSObject

/**
 *  主色调
 */
@property (nonatomic, copy)     UIColor     *mainColor;

/**
 *  设置代理
 */
@property (nonatomic, weak) id<MKDebugDelegate> delegate;

/**
 *  http请求数据是否加密，默认不加密
 */
@property (nonatomic, assign)   BOOL        isHttpRequestEncrypt;

/**
 *  http响应数据是否加密，默认不加密
 */
@property (nonatomic, assign)   BOOL        isHttpResponseEncrypt;

/**
 *  日志最大数量，默认50条
 */
@property (nonatomic, assign)   int         maxLogsCount;

/**
 *  设置只抓取的域名，忽略大小写，默认抓取所有
 */
@property (nonatomic, strong)   NSArray     *arrOnlyHosts;


+ (instancetype)shareInstance;
/**
 *  启用
 */
- (void)enableDebugMode;


@end
