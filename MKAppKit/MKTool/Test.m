
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "Test.h"
#import <UIKit/UIKit.h>

#import "MKFunctions.h"

@implementation Test
+(void)test{
    UIColor *c1 = MKColorWithHex(0xffffb400);
    UIColor *c2 = [UIColor colorWithRed:255 green:180 blue:0 alpha:1];
    NSString *c3 = MKHexWithColor(c1);
}
@end
