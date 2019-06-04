/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "MKCrashGuardProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (MKCrashGuard)<MKCrashGuardProtocol>

/**  防护：
 *
 * - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
 * - (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc
 * - (void)deleteCharactersInRange:(NSRange)range
 *
 */

@end

NS_ASSUME_NONNULL_END





