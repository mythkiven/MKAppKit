
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFileManager : NSObject

+ (NSString *)documentsDirectoryPath;
+ (NSURL *)documentsDirectoryURL;
+ (NSString *)libraryDirectoryPath;
+ (NSString *)cacheDirectoryPath;
+ (NSString *)temporaryDirectoryPath; 

@end

NS_ASSUME_NONNULL_END
