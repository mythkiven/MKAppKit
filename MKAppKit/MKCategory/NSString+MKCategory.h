/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSString (MKCategory)

#pragma mark 拼音

/*
 返回汉字拼音,无声调
 */
- (NSString *)mk_pinyin;

/*
 返回汉字拼音,包含声调
 */
- (NSString *)mk_pinyinAndTone;

#pragma mark SIZE

/*
 以1024作单位换算,默认至少保留3位有效数字
 */
+ (NSString *)mk_stringFromFileSize:(uint64_t)byteCount;

/*
 以1000作单位换算,默认至少保留3位有效数字
 */
+ (NSString *)mk_stringFromDiskSize:(uint64_t)byteCount;

/*
 byteCount:byte数量
 delimiter:数字与单位之间的间隔
 diskMode:YES时以1000作单位换算，NO时以1024作单位换算
 significant:保留有效长度
 */
+ (NSString *)mk_stringFromSize:(uint64_t)byteCount delimiter:(NSString *)delimiter diskMode:(BOOL)diskMode significant:(uint8_t)length;

@end
