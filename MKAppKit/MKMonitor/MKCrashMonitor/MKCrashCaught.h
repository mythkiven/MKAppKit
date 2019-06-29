//
//  MKCrashCaught.h
//  MKApp
//
//  Created by apple on 2019/6/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//

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

