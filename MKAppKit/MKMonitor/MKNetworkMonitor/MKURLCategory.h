//
//  MKURLCategory.h
//  MKApp
//
//  Created by apple on 2019/7/2.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKURLCategory : NSObject

@end

NS_ASSUME_NONNULL_END



@interface NSURLRequest (Identify)
- (NSString *)requestId;
- (void)setRequestId:(NSString *)requestId;
- (NSNumber*)startTime;
- (void)setStartTime:(NSNumber*)startTime;
@end


@interface NSURLResponse (Data)
- (NSData *)responseData;
- (void)setResponseData:(NSData *)responseData; 
@end


@interface NSURLSession (Swizzling) 
@end

@interface NSURLSessionTask (Data)
- (NSString*)taskDataIdentify;
- (void)setTaskDataIdentify:(NSString*)name;
- (NSMutableData*)responseDatas;
- (void)setResponseDatas:(NSMutableData*)data; 
@end
