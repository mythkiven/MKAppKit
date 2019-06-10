//
//  MKException.h
//  MKApp
//
//  Created by apple on 2019/6/5.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCrashGuardConst.h"

NS_ASSUME_NONNULL_BEGIN

__attribute__((overloadable)) void mkHandleCrashException(NSException* exception);
__attribute__((overloadable)) void mkHandleCrashException(NSException* exception,NSString* extraInfo);
__attribute__((overloadable)) void mkHandleCrashException(NSString* exceptionMessage);
__attribute__((overloadable)) void mkHandleCrashException(NSString* exceptionMessage,NSString* extraInfo);


@protocol MKExceptionHandle<NSObject>
- (void)handleCrashException:(nonnull NSString *)exceptionMessage extraInfo:(nullable NSDictionary*)extraInfo;
@end


@interface MKException : NSObject <MKExceptionHandle>

@property(nonatomic,readwrite,weak) id<MKExceptionHandle> delegate;

+ (instancetype)shareException;

- (void)handleCrashInException:(nonnull NSException *)exceptionMessage extraInfo:(nullable NSString*)extraInfo;

@end

NS_ASSUME_NONNULL_END
