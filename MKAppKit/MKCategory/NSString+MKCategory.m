/**
 *
 * Created by https://github.com/mythkiven/ on 19/08/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "NSString+MKCategory.h"

@implementation NSString (MKCategory)

#pragma mark 拼音

- (NSString *)mk_pinyin
{
    return [self mk_pinyinWithTone:NO];
}

- (NSString *)mk_pinyinAndTone
{
    return [self mk_pinyinWithTone:YES];
}

- (NSString *)mk_pinyinWithTone:(BOOL)tone
{
    NSMutableString *string = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)string,NULL,kCFStringTransformMandarinLatin,NO);
    if (!tone)
    {
        CFStringTransform((__bridge CFMutableStringRef)string,NULL,kCFStringTransformStripDiacritics,NO);
    }
    return [[NSString alloc] initWithString:string];
}

#pragma mark SIZE

+ (NSString *)mk_stringFromFileSize:(uint64_t)byteCount
{
    return [self mk_stringFromSize:byteCount delimiter:@" " diskMode:NO significant:3];
}

+ (NSString *)mk_stringFromDiskSize:(uint64_t)byteCount
{
    return [self mk_stringFromSize:byteCount delimiter:@" " diskMode:YES significant:3];
}

+ (NSString *)mk_stringFromSize:(uint64_t)byteCount delimiter:(NSString *)delimiter diskMode:(BOOL)diskMode significant:(uint8_t)length
{
    const NSString* sizeUnit[] = {@"B",@"KB",@"MB",@"GB",@"TB",@"PB",@"EB",@"ZB",@"YB"};
    
    NSInteger idx = 0;
    double floatSize = byteCount;
    while (floatSize>1000 && idx < (sizeof(sizeUnit)/sizeof(sizeUnit[0])-1))
    {
        idx++;
        if (diskMode)
            floatSize /= 1000;
        else
            floatSize /= 1024;
    }
    
    if (idx == 0)
    {
        return [NSString stringWithFormat:@"%.0f%@%@",floatSize,delimiter?delimiter:@"",sizeUnit[idx]];
    }else
    {
        NSString *formatString = [NSString stringWithFormat:@"%%.%df%%@%%@",MAX((int)length - ((int)log10(floatSize) + 1), 0)];
        return [NSString stringWithFormat:formatString,floatSize,delimiter?delimiter:@"",sizeUnit[idx]];
    }
}

@end
