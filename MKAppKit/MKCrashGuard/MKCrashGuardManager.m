/**
 *
 * Created by https://github.com/mythkiven/ on 19/05/29.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKCrashGuardManager.h"


@implementation MKCrashGuardManager


#pragma mark - public

/**
 在 application: didFinishLaunchingWithOptions: 中调用，启动 App 守护
 */
+ (void)executeAppGuard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject mk_guardSelector:YES];
        [NSArray crashGuardExchangeMethod];
        [NSMutableArray crashGuardExchangeMethod];
        [NSDictionary crashGuardExchangeMethod];
        [NSMutableDictionary crashGuardExchangeMethod];
        [NSString crashGuardExchangeMethod];
        [NSMutableString crashGuardExchangeMethod];
        [NSAttributedString crashGuardExchangeMethod];
        [NSMutableAttributedString crashGuardExchangeMethod];
        
//        [NSObject performSelector:@selector(mk_guardSelector:) withObject:@YES];
//        [NSArray performSelector:@selector(crashGuardExchangeMethod)];
//        [NSMutableArray performSelector:@selector(crashGuardExchangeMethod)];
//        [NSDictionary performSelector:@selector(crashGuardExchangeMethod)];
//        [NSMutableDictionary performSelector:@selector(crashGuardExchangeMethod)];
//        [NSString performSelector:@selector(crashGuardExchangeMethod)];
//        [NSMutableString performSelector:@selector(crashGuardExchangeMethod)];
//        [NSAttributedString performSelector:@selector(crashGuardExchangeMethod)];
//        [NSMutableAttributedString performSelector:@selector(crashGuardExchangeMethod)];
    });
}

/**
 启用 "unrecognized selector sent to instance" crash 防护，请传入需要防护的 类名或类名前缀
 
 @param classPrefixs 防护的类名或类名前缀
 */
+ (void)guardSelectorWithClassPrefixs:(NSArray<NSString *> *)classPrefixs{
    [NSObject mk_guardSelectorWithClassPrefixs:classPrefixs];
}


#pragma mark - private

// 类方法的交换
+ (void)exchangeClassMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector {
    Method method1 = class_getClassMethod(anClass, systemSelector);
    Method method2 = class_getClassMethod(anClass, swizzledSelector);
    method_exchangeImplementations(method1, method2);
}

// 对象方法的交换
+ (void)exchangeInstanceMethod:(Class)anClass systemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(anClass, systemSelector);
    Method swizzledMethod = class_getInstanceMethod(anClass, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(anClass,
                    systemSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(anClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}

//  crash信息处理
+ (void)printErrorInfo:(NSException *)exception describe:(NSString *)description {
    //堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [MKCrashGuardManager getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"crash 定位失败,请结合函数调用栈来排查";
    }
    NSString *errorName = exception.name;
    NSString *errorReason = exception.reason;
    //errorReason 可能为 -[__NSCFConstantString avoidCrashCharacterAtIndex:]: Range or index out of bounds
    //将avoidCrash去掉
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"avoidCrash" withString:@""];
    NSString *errorPlace = [NSString stringWithFormat:@"%@",mainCallStackSymbolMsg];
    NSString *logErrorMessage = [NSString stringWithFormat:@"%@\n ErrorName : %@\n ErrorReason : %@\n ErrorPlace : %@\n defaultToDo : %@ \n Exception : %@ \n CallStackSymbols : %@ \n %@",MKCrashGuardSeparatorWithFlag, errorName, errorReason, errorPlace, description,exception,callStackSymbolsArr,MKCrashGuardSeparator];
    // 打印错误日志
    MKCrashGuardLog(@"%@\n\n\n",logErrorMessage);
    
    // 写入本地 log 文件
    
    // 发出通知
    logErrorMessage = logErrorMessage;
    NSDictionary *errorInfoDic = @{
                                   @"ErrorName"         : errorName,
                                   @"ErrorPlace"        : errorPlace,
                                   @"ErrorReason"       : errorReason,
                                   @"exception"         : exception,
                                   @"defaultToDo"       : description,
                                   @"callStackSymbols"  : callStackSymbolsArr,
                                   };
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCrashGuardNotification object:nil userInfo:errorInfoDic];
    });
}

 
@end

