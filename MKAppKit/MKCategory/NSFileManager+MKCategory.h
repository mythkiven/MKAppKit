/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSFileManager (MKCategory)

/*
 快速计算文件/目录的size
 返回实际的byte数
 */
- (uint64_t)mk_fileSizeAtPath:(NSString *)filePath;

/*
 快速计算文件/目录的size
 返回占用磁盘空间
 */
- (uint64_t)mk_diskSizeAtPath:(NSString *)filePath;

/*
 返回是否为替身文件
 */
- (BOOL)mk_isAlias:(NSString *)aliasPath;

/*
 返回替身文件的原身
 */
- (NSString *)mk_resolvingAlias:(NSString *)aliasPath;

/*
 创建替身文件
 */
- (BOOL)mk_createAlias:(NSString *)aliasPath fromPath:(NSString *)originalPath;

@end
