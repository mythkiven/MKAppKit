
/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MKTimeStamp [[NSDate date] timeIntervalSince1970] * 1000l

#define WKInvalTimer(timer) { \
if (timer != nil) { \
[timer invalidate]; \
[timer release]; \
timer = nil; \
} \
}

#define mkWeakify(var) __weak typeof(var) AHKWeak_##var = var;
#define mkStrongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")



static inline UIColor* MKColorWithHex(NSUInteger hex){
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF)
                           green:((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF)
                            blue:((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF)
                           alpha:hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1];
}
static inline NSString* MKHexWithColor(UIColor *color) {
    CGFloat red, green, blue, alpha;
    if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) {
        [color getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }
    red = roundf(red * 255.f);
    green = roundf(green * 255.f);
    blue = roundf(blue * 255.f);
    alpha = roundf(alpha * 255.f);
    return [NSString stringWithFormat:@"0x%08x", ((uint)alpha << 24) | ((uint)red << 16) | ((uint)green << 8) | ((uint)blue)]; 
}


extern NSString* MKStringSearch(NSString* string, NSString* pattern);
extern NSString* MKStringReplace(NSString* string, NSString* pattern, NSString* replaceString);
extern NSString* MKStringRemovePrefix(NSString* string, NSString* prefix);
extern NSString* MKStringRemoveSuffix(NSString* string, NSString* suffix);

extern BOOL MKPathExists(NSString* path, NSString** fileType);
extern BOOL MKPathFileExists(NSString* path);
extern BOOL MKPathDirectoryExists(NSString* path);



/** GCD定时器
 dispatch_source_t timer =  mk_createGCDTimer(interval, interval, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 [self dosomething];// 需要及时执行cancle: dispatch_source_cancel(timer);
 });

 @param interval 间隔多久触发定时任务
 @param leeway 触发定时任务时，允许的时间差,如果不确定，就设置为 0 或 interval / 10000
 @param queue 执行队列
 @param block 定时任务
 @return timer
 */
extern dispatch_source_t mk_createGCDTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block);
