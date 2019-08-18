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



@interface NSURLRequest (MKIdentify)
- (NSString *)requestId;
- (void)setRequestId:(NSString *)requestId;
- (NSNumber*)startTime;
- (void)setStartTime:(NSNumber*)startTime;
@end


@interface NSURLResponse (MKData)
- (NSData *)responseData;
- (void)setResponseData:(NSData *)responseData; 
@end


@interface NSURLSession (MKSwizzling)
@end

@interface NSURLSessionTask (MKData)
- (NSString*)taskDataIdentify;
- (void)setTaskDataIdentify:(NSString*)name;
- (NSMutableData*)responseDatas;
- (void)setResponseDatas:(NSMutableData*)data; 
@end
