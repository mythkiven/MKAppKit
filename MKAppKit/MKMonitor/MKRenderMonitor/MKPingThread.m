//
//  MKPingThread.m
//  MKApp
//
//  Created by apple on 2019/6/24.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import "MKPingThread.h"
#import "MKThreadTraceLogger.h"

#define PMainThreadWatcher_Watch_Interval     0.5.0f
#define PMainThreadWatcher_Warning_Level     (16.0f/1000.0f)

#define Notification_PMainThreadWatcher_Ping    @"Notification_PMainThreadWatcher_Ping"
#define Notification_PMainThreadWatcher_CancelPing    @"Notification_PMainThreadWatcher_CancelPing"


dispatch_source_t createGCDTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, interval), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}




@interface MKPingThread ()
@property (nonatomic, strong) dispatch_source_t                 pingTimer;
@property (nonatomic, strong) dispatch_source_t                 pongTimer;
@end

@implementation MKPingThread

+ (instancetype)sharedInstance
{
    static MKPingThread* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MKPingThread new];
    });
    
    return instance;
}

- (void)startWatch {
    if ([NSThread isMainThread] == false) {
        NSLog(@"Error: startWatch must be called from main thread!");
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectPingFromWorkerThread) name:Notification_PMainThreadWatcher_Ping object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectPongFromMainThread) name:Notification_PMainThreadWatcher_CancelPing object:nil];
    uint64_t interval = PMainThreadWatcher_Warning_Level * NSEC_PER_SEC;// 16.7ms
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.pingTimer = createGCDTimer(interval, interval / 10000, queue , ^{
        self.pongTimer = createGCDTimer(interval, interval / 10000, queue, ^{
            if (_pongTimer) {
                dispatch_source_cancel(_pongTimer);
                _pongTimer = nil;
                // 出现了缺帧，卡顿的情况！！！！
            }
        });
        // 主线程发出 NSNotification_ping,必然会在主线程接收 NSNotification_ping
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PMainThreadWatcher_Ping object:nil];
        });
    });
}
// 如果 runloop 能够响应主线程的 NSNotification_ping,则发一个  NSNotification_cancelping
- (void)detectPingFromWorkerThread {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PMainThreadWatcher_CancelPing object:nil];
}
// 如果 runloop 能够响应主线程的 NSNotification_cancelping,则直接取消 strongself.pongTimer 的定时任务
- (void)detectPongFromMainThread {
    if (self.pongTimer) {
        dispatch_source_cancel(_pongTimer);
        _pongTimer = nil;
    }
}

@end
