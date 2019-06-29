//
//  NSNumber+MKCrashGuard.h
//  MKAppKit
//
//  Created by apple on 2019/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (MKCrashGuard)

/*
 可避免以下crash
 isEqualToNumber:
 compare:
 */
+ (void)guardNSNumberCrash;


@end

NS_ASSUME_NONNULL_END
