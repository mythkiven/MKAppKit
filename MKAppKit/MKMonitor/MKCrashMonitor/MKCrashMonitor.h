/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCrashMonitor : NSObject

@end

void mk_registerCrashHandler(void);
void mk_reportCrash(NSString *crashLog);

NS_ASSUME_NONNULL_END
