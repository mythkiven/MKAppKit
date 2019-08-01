/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSData (MKCategory)

/**
 @brief 返回有效的UTF8编码的NSData数据,替换掉无效的编码
 **/
- (NSData *)mk_UTF8Data;

@end
