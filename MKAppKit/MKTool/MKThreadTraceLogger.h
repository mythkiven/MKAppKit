//
//  MKThreadTraceLogger.h
//  MKApp
//
//  Created by apple on 2019/6/25.
//  Copyright © 2019 MythKiven. All rights reserved.
//

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
