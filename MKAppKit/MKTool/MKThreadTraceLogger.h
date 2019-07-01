/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>



#define MKTTLOG NSLog(@"%@",[MKThreadTraceLogger mkThreadTraceOfCurrentThread]);
#define MKTTLOG_MAIN NSLog(@"%@",[MKThreadTraceLogger mkThreadTraceOfMainThread]);
#define MKTTLOG_ALL NSLog(@"%@",[MKThreadTraceLogger mkThreadTraceOfAllThread]);

NS_ASSUME_NONNULL_BEGIN


@interface MKThreadTraceLogger : NSObject

+ (NSString *)mkThreadTraceOfAllThread;
+ (NSString *)mkThreadTraceOfCurrentThread;
+ (NSString *)mkThreadTraceOfMainThread;
+ (NSString *)mkThreadTraceOfNSThread:(NSThread *)thread;

@end

NS_ASSUME_NONNULL_END
