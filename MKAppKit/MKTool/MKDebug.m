
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKDebug.h"
#import "MKFileUtils.h"
#import "MKCrashMonitor.h"


@implementation MKDebug

+ (void)debugRegister{
    //  日志保存
    [MKFileUtils saveLogToLocalFile:nil];
    //  crash 抓取
    mk_registerCrashHandler();
    // tree
    [MKFileUtils treeSanbox];
}
+ (void)enableDebug {
    
    
#ifdef DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MKSandbox sharedInstance] enableSwipe];
    });
#endif
    
}

@end
