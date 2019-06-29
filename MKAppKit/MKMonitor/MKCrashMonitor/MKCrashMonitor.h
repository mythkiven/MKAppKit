//
//  MKCrashMonitor.h
//  MKApp
//
//  Created by apple on 2019/6/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCrashMonitor : NSObject

@end

void mk_registerCrashHandler(void);

NS_ASSUME_NONNULL_END
