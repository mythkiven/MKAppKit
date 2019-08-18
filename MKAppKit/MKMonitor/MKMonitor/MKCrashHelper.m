/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKCrashHelper.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

const int maxCrashLogNum  = 20;

@interface MKCrashHelper() {
    NSString*       _crashLogPath;
    NSMutableArray* _plist;
}
@property (nonatomic,assign) BOOL isInstalled;
@end

@implementation MKCrashHelper

+ (instancetype)sharedInstance {
    static MKCrashHelper* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MKCrashHelper new];
    });
    return instance;
}


+ (NSArray *)backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = 0;i < 32;i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (id)init{
    self = [super init];
    if (self){
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* sandBoxPath  = [paths objectAtIndex:0];
        _crashLogPath = [sandBoxPath stringByAppendingPathComponent:@"MKCrashLog"];
        
        if( NO == [[NSFileManager defaultManager] fileExistsAtPath:_crashLogPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:_crashLogPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        //creat plist
        if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]]) {
            _plist = [[NSMutableArray arrayWithContentsOfFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]] mutableCopy];
        }else{
            _plist = [NSMutableArray new];
        }
    }
    return self;
}

- (NSDictionary* )crashForKey:(NSString *)key {
    NSString* filePath = [[_crashLogPath stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dict;
}

- (NSArray* )crashPlist {
    return [_plist copy];
}

- (NSArray* )crashLogs{
    NSMutableArray* ret = [NSMutableArray new];
    for (NSString* key in _plist) {
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSString* path = [filePath stringByAppendingString:@".plist"];
        NSDictionary* log = [NSDictionary dictionaryWithContentsOfFile:path];
        [ret addObject:log];
    }
    return [ret copy];
}


- (NSDictionary* )crashReport {
    for (NSString* key in _plist) {
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dict;
    }
    return nil;
    
}

- (void)saveException:(NSException*)exception {
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
    
    [self saveToFile:dict];
    
}

- (void)saveSignal:(int) signal {
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    [detail setObject:@(signal) forKey:@"signal type"];
    [self saveToFile:detail];
}

- (void)saveToFile:(NSMutableDictionary*)dict {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    //add date
    [dict setObject:dateString forKey:@"date"];
    //save path
    NSString* savePath = [[_crashLogPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".plist"];
    //save to disk
    BOOL succeed = [ dict writeToFile:savePath atomically:YES];
    if ( NO == succeed ) {
        NSLog(@"MKDebugTool:crash report failed!");
    }else{
        NSLog(@"MKDebugTool:save crash report succeed!");
    }
    [_plist insertObject:dateString atIndex:0];
    [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    
    if (_plist.count > maxCrashLogNum) {
        [[NSFileManager defaultManager] removeItemAtPath:[_crashLogPath stringByAppendingPathComponent:_plist[0]] error:nil];
        [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    }
}

#pragma mark - register
void mk_HandleException(NSException *exception) {
    [[MKCrashHelper sharedInstance] saveException:exception];
    [exception raise];
}

void mk_SignalHandler(int sig) {
//    [[MKCrashHelper sharedInstance] saveSignal:sig];
//    signal(sig, SIG_DFL);
//    raise(sig);
}

- (void)install {
    if (_isInstalled) {
        return;
    }
    _isInstalled = YES;
    //注册回调函数
    NSSetUncaughtExceptionHandler(&mk_HandleException);
    signal(SIGABRT, mk_SignalHandler);
    signal(SIGILL, mk_SignalHandler);
    signal(SIGSEGV, mk_SignalHandler);
    signal(SIGFPE, mk_SignalHandler);
    signal(SIGBUS, mk_SignalHandler);
    signal(SIGPIPE, mk_SignalHandler);
}

- (void)dealloc {
    signal( SIGABRT,	SIG_DFL );
    signal( SIGBUS, SIG_DFL );
    signal( SIGFPE, SIG_DFL );
    signal( SIGILL, SIG_DFL );
    signal( SIGPIPE,	SIG_DFL );
    signal( SIGSEGV,	SIG_DFL );
}
@end

