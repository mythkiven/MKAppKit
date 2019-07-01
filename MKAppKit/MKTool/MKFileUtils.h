
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */



#define MK_MAX_PATH_LENGTH 500

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFileUtils : NSObject

+ (NSString *)documentsDirectoryPath;
+ (NSURL *)documentsDirectoryURL;
+ (NSString *)libraryDirectoryPath;
+ (NSString *)cacheDirectoryPath;
+ (NSString *)temporaryDirectoryPath;
+ (void)treeSanbox;
/**
 NSlog printf 日志保存进沙盒
 @param savePath 保存的路径，可为空。将使用默认路径
 @return return 保存的路径
 */
+ (NSString*)saveLogToLocalFile:(nullable NSString*)savePath;

/**
 * 以一种安全的方式读取文件，基于底层api
 */
NSString* mk_safe_readFile(NSString *filePath);
/**
 * 以一种安全的方式删除文件，基于底层api
 */
bool mk_safe_deletereFile(NSString *filePath);
/**
 * 以一种安全的方式删除文件内容，基于底层api
 */
bool mk_safe_deleteContentsOfPath(NSString *filePath);
/**
 * 文件是否存在，基于底层api
 */
bool mk_isFileExist(NSString *filePath);
@end

NS_ASSUME_NONNULL_END
