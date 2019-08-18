/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKRunLoopWatch.h"
#import "MKMacro.h"
#include <execinfo.h>
#import <libkern/OSAtomic.h>
#import "MKFileUtils.h"
#import "MKThreadTrace.h"


#define MKMainThreadWatcher_Interval    (16.0f/1000.0f)

@interface MKRunLoopWatch ()

@property (assign,nonatomic) CFRunLoopObserverRef runloopObserver;
@property (strong,nonatomic) dispatch_semaphore_t semaphore;
@property (assign,nonatomic) NSInteger timeOutCount;
@property (assign,nonatomic) CFRunLoopActivity activity;

@end

@implementation MKRunLoopWatch


-(void)watchRenderWithLogPath:(NSString*)pathToSaveLog{
    if(_runloopObserver){
        return;
    }
    _semaphore = dispatch_semaphore_create(0);
    
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL};
    _runloopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, true, -0x7FFFFFFF, runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _runloopObserver, kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            uint64_t interval = MKMainThreadWatcher_Interval * NSEC_PER_SEC;
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,interval);
            long semaphoreWait = dispatch_semaphore_wait(self.semaphore, time); 
            if(semaphoreWait != 0){
                if(!self.runloopObserver) {
                    self.timeOutCount = 0;
                    self.semaphore  = 0;
                    self.activity = 0;
                    return;
                }
                if(self.activity == kCFRunLoopAfterWaiting || self.activity == kCFRunLoopBeforeSources) {
                    // 超过两帧就上报
                    if(++self.timeOutCount < 3){
                        continue;
                    }
                    NSLog(@"发现一次延时");
                    NSLog(@"callStackSymbols：%@",[NSThread callStackSymbols]);
                    NSMutableDictionary *mdic = @[].mutableCopy;
                    [mdic setObject:@"Frame loss" forKey:@"reason"];
                    [mdic setObject:mk_callStackSymbols() forKey:@"thread"];
                    if(pathToSaveLog){
                        [MKFileUtils saveToDir:mk_isFileExist(pathToSaveLog)?pathToSaveLog:MK_RENDER_DIR content:mdic fileName:@"MKWatchDog"];
                    }
                }
            }else{
                self.timeOutCount = 0;
            }
        }
    });
}



volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 0;
const NSInteger UncaughtExceptionHandlerReportAddressCount = UncaughtExceptionMaximum;
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    MKRunLoopWatch *appFluencyMonitor = (__bridge MKRunLoopWatch*)info;
    appFluencyMonitor.activity = activity;
    dispatch_semaphore_signal(appFluencyMonitor.semaphore); 
}


@end
