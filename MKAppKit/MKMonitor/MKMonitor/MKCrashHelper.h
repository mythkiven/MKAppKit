/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface MKCrashHelper : NSObject

+ (instancetype)sharedInstance;
- (void)install;
- (NSDictionary* )crashForKey:(NSString* )key;
- (NSArray* )crashPlist;
- (NSArray* )crashLogs;

@end
