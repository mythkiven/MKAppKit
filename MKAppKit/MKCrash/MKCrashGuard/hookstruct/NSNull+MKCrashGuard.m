/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/11.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "NSNull+MKCrashGuard.h" 
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>

MK_SYNTH_DUMMY_CLASS(NSNull_MKCrashGuard)
@implementation NSNull (MKCrashGuard)

+ (void)guardNSNull {
//    mk_swizzleInstanceMethod(self,@selector(length),@selector(guardLength));
}

- (NSInteger)guardLength {
    return 0;
}

@end
