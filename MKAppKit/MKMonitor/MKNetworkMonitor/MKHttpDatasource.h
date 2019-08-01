/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MKHttpModel : NSObject
@property (nonatomic,copy)NSString  *requestId;
@property (nonatomic,copy)NSURL     *url;
@property (nonatomic,copy)NSString  *method;
@property (nonatomic,copy)NSString  *requestBody;
@property (nonatomic,copy)NSString  *statusCode;
@property (nonatomic,copy)NSData    *responseData;
@property (nonatomic,assign)BOOL    isImage;
@property (nonatomic,copy)NSString  *mineType;
@property (nonatomic,copy)NSString  *startTime;
@property (nonatomic,copy)NSString  *totalDuration;


/**
 *  <#Description#>
 *
 *  @param data <#data description#>
 *  @param resp <#resp description#>
 *  @param req  <#req description#>
 */
+ (void)dealwithResponse:(NSData *)data resp:(NSURLResponse*)resp req:(NSURLRequest *)req;
@end

@interface MKHttpDatasource : NSObject

@property (nonatomic,strong,readonly) NSMutableArray    *httpArray;
@property (nonatomic,strong,readonly) NSMutableArray    *arrRequest;

+ (instancetype)shareInstance;
/**
 *  记录http请求
 *
 *  @param model http
 */
- (void)addHttpRequset:(MKHttpModel*)model;

/**
 *  清空
 */
- (void)clear;

/**
 *  解析
 *
 *  @param data
 *
 *  @return 
 */
+ (NSString *)prettyJSONStringFromData:(NSData *)data;

@end
