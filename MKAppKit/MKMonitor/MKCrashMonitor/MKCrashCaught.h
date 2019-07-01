/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
 
void mk_registerSignalHandler(void);
void mk_registerExceptionHandler(void);

/**
 根据 key 获取 crash
 */
NSDictionary *mk_crashForKey(NSString *key);
/**
 获取全部 crash 文件
 */
NSArray *mk_getCrashPlist(void);
/**
 获取全部 crash 文件
 */
NSArray *mk_getCrashLogs(void);
/**
 获取全部 crash 文件
 */
NSDictionary *mk_getCrashReport(void);

