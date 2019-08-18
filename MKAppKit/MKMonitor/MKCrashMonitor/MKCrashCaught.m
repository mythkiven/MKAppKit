/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKCrashCaught.h"
#include <libkern/OSAtomic.h>
#include <pthread.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>

#import "MKMacro.h"
#import "MKDevice.h"
#import "MKFileUtils.h"
#import "MKThreadTrace.h"


// 最大处理数量
const int mk_caughtExceptionMaximum  = 20;
volatile int32_t mk_caughtExceptionCount = 0;

// 其他sdk添加的异常处理
static NSUncaughtExceptionHandler *mk_old_exception_handler  = NULL;


#pragma mark -  save to file -


static NSMutableArray *mk_logPlist;

NSMutableArray *mk_plist(){
    if(! mk_logPlist){
        mk_logPlist = [NSMutableArray new];
    }
    if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[MK_CRASH_DIR stringByAppendingPathComponent:[MK_FILE_NAME_TAG stringByAppendingString:@"mkCrashLog.plist"]]]){
        mk_logPlist = [[NSMutableArray arrayWithContentsOfFile:[MK_CRASH_DIR stringByAppendingPathComponent:[MK_FILE_NAME_TAG stringByAppendingString:@"mkCrashLog.plist"]]] mutableCopy];
    }
    return mk_logPlist;
}

void mk_saveToFile(NSMutableDictionary *dict) {
    [MKFileUtils saveToDir:MK_CRASH_DIR content:dict fileName:@"mkCrashInfo"];
}

void mk_saveException(NSException*exception) {
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    if(exception.name){
        [detail setObject:exception.name forKey:@"name"];
    }
    if(exception.reason){
        [detail setObject:exception.reason forKey:@"reason"];
    }
    if(exception.userInfo){
        [detail setObject:exception.userInfo forKey:@"userInfo"];
    }
    if(exception.callStackSymbols){
        [detail setObject:exception.callStackSymbols forKey:@"callStack"];
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"exception" forKey:@"type"];
    [dict setObject:detail forKey:@"info"];
    mk_saveToFile(dict);
    NSSetUncaughtExceptionHandler(NULL);
}
void mk_saveSignal(int sig) {
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    [detail setObject:@(sig) forKey:@"signal type"];
    [detail setObject:mk_callStackSymbols() forKey:@"backtrace"];
    mk_saveToFile(detail);
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGBUS,  SIG_DFL);
    signal(SIGFPE,  SIG_DFL);
    signal(SIGILL,  SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGHUP,  SIG_DFL);
    signal(SIGINT,  SIG_DFL);
    signal(SIGQUIT, SIG_DFL);
}


#pragma mark  - signal -

void mk_signal_Handler(int sig) {
    int32_t exceptionCount = OSAtomicIncrement32(&mk_caughtExceptionCount);//自动增加一个32位的值
    if (exceptionCount > mk_caughtExceptionMaximum){
        signal(sig, SIG_DFL);
        return;
    }
    mk_saveSignal(sig);
}

void mk_registerSignalHandler(void) {
    signal(SIGHUP, mk_signal_Handler);
    signal(SIGINT, mk_signal_Handler);
    signal(SIGQUIT, mk_signal_Handler);
    
    signal(SIGABRT, mk_signal_Handler);
    signal(SIGILL, mk_signal_Handler);
    signal(SIGSEGV, mk_signal_Handler);
    signal(SIGFPE, mk_signal_Handler);
    signal(SIGBUS, mk_signal_Handler);
    signal(SIGPIPE, mk_signal_Handler);
}


#pragma mark  - Exception -
void mk_unRegisterExceptionHandler() {
    if(mk_old_exception_handler){
        NSSetUncaughtExceptionHandler(mk_old_exception_handler);
    }
}

void mk_register_exception_handler(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&mk_caughtExceptionCount);//自动增加一个32位的值
    if (exceptionCount > mk_caughtExceptionMaximum){
        MKWarningLog(@"exception 超过上限 %d，不在处理",mk_caughtExceptionMaximum);
        mk_unRegisterExceptionHandler();
        return;
    }
    mk_saveException(exception);
    // [exception raise] 用于调用 objc_exception_throw 抛出异常。 一般不建议抛出异常，会消耗一些资源。
    mk_unRegisterExceptionHandler(); // 注册回去
}

void mk_registerExceptionHandler(void){
    mk_old_exception_handler = NSGetUncaughtExceptionHandler();
    if(mk_old_exception_handler != NULL && mk_old_exception_handler != mk_register_exception_handler) {
        MKWarningLog(@"捕获到其他SDK注册的 ExceptionHandler: %s - UncaughtExceptionHandler=%p",__func__,NSGetUncaughtExceptionHandler());
    }
    NSSetUncaughtExceptionHandler(&mk_register_exception_handler);
}



#pragma mark  - action -


NSDictionary *mk_crashForKey(NSString *key) {
    NSString* filePath = [[MK_CRASH_DIR stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

NSArray *mk_getCrashPlist() {
    return [mk_plist() copy];
}
NSArray *mk_getCrashLogs() {
    NSMutableArray* ret = [NSMutableArray new];
    for (NSString* key in mk_plist()) {
        NSString* filePath = [MK_CRASH_DIR stringByAppendingPathComponent:key];
        NSString* path = [filePath stringByAppendingString:@".plist"];
        NSDictionary* log = [NSDictionary dictionaryWithContentsOfFile:path];
        [ret addObject:log];
    }
    return [ret copy];
}
NSDictionary *mk_getCrashReport() {
    for (NSString* key in mk_plist()) {
        NSString* filePath = [MK_CRASH_DIR stringByAppendingPathComponent:key];
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dict;
    }
    return nil;
    
}
