//
//  MKCrashMonitor.m
//  MKApp
//
//  Created by apple on 2019/6/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import "MKCrashMonitor.h"
#import "MKCrashCaught.h"


@implementation MKCrashMonitor


@end

void mk_registerCrashHandler(void){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mk_registerSignalHandler();
        mk_registerExceptionHandler(); 
    });
    
    
    
    
    NSArray *a1 = mk_getCrashPlist();
    NSArray *a2 = mk_getCrashLogs();
    NSDictionary *a3 = mk_getCrashReport();
    
    NSLog(@"%@",a1);
    NSLog(@"%@",a2);
    NSLog(@"%@",a3);
    /**
     根据 key 获取 crash
     */
    //    NSDictionary *mk_crashForKey(NSString *key);
    
    
}
