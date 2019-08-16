/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/16.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKLockSentinel.h"

@implementation MKLockSentinel {
    id<NSLocking> lock_;
}

- (id)initWithLock:(id<NSLocking>)obj { 
    if (self = [super init]) {
        lock_ = obj;
        [lock_ lock];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"--->delloc");
    [lock_ unlock];
}

@end
