/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define MKCrashGuardSystemVersion(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

#ifdef DEBUG
#define MKCrashGuardLog(fmt, ...) NSLog((@"MKCrashGuardLog:" fmt), ##__VA_ARGS__)
#else 
#define MKCrashGuardLog(...)
#endif

#ifndef MK_SYNTH_DUMMY_CLASS
#define MK_SYNTH_DUMMY_CLASS(_name_) \
@interface MK_SYNTH_DUMMY_CLASS ## _name_ : NSObject @end \
@implementation MK_SYNTH_DUMMY_CLASS ## _name_ @end
#endif 


NS_ASSUME_NONNULL_BEGIN

@interface MKCrashGuardConst : NSObject

- (void)mkProxyMethod;

@end
NS_ASSUME_NONNULL_END
