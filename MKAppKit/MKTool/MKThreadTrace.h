/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>



#define MKTTLOG NSLog(@"%@",[MKThreadTrace mkThreadTraceOfCurrentThread]);
#define MKTTLOG_MAIN NSLog(@"%@",[MKThreadTrace mkThreadTraceOfMainThread]);
#define MKTTLOG_ALL NSLog(@"%@",[MKThreadTrace mkThreadTraceOfAllThread]);

NS_ASSUME_NONNULL_BEGIN


@interface MKThreadTrace : NSObject

+ (NSString *)mkThreadTraceOfAllThread;
+ (NSString *)mkThreadTraceOfCurrentThread;
+ (NSString *)mkThreadTraceOfMainThread;
+ (NSString *)mkThreadTraceOfNSThread:(NSThread *)thread;

extern NSString *mk_callStackSymbols(void);

@end





NS_ASSUME_NONNULL_END
