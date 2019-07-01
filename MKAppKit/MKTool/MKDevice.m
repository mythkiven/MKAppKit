/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/28.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKDevice.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <malloc/malloc.h>
#import <mach-o/arch.h>
#import <mach/mach.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#include <sys/stat.h> // struct stat stat_info;
#import <dlfcn.h> // Dl_info dylib_info;



@implementation MKDevice 

- (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}
- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
- (NSString *)appBundleVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)deviceName {
    return [UIDevice currentDevice].name;
}
- (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return  self.modelDic[deviceModel];
}
- (NSString *)deviceVersion {
    return  [[UIDevice currentDevice].systemName stringByAppendingString:[UIDevice currentDevice].systemVersion];
}
- (NSString *)deviceLanguage {
    return [NSLocale preferredLanguages].firstObject;
}
- (NSString *)batteryPercent {
//    NSArray *infoArray2 = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//    for (id info in infoArray2){
//        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarSignalStrengthItemView")]){ // 运营商信号： _signalStrengthRaw   _signalStrengthBars
//            NSLog(@"");
//        }else if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")]){ // 运营商信息 _serviceString
//            NSLog(@"");// po [info valueForKeyPath:@""]  _serviceString 中国联通
//        }else  if ([info isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]){ // 网络类型 wifi信号 _dataNetworkType _wifiStrengthRaw _wifiStrengthBars
//            NSLog(@""); // _dataNetworkType=1，2，3，5 分别对应的网络状态是2G、3G、4G及WIFI
//        }else if ([info isKindOfClass:NSClassFromString(@"UIStatusBarBatteryPercentItemView")]){ // 电量百分比
//            NSLog(@"");
//        }else if ([info isKindOfClass:NSClassFromString(@"UIStatusBarLocationItemView")]){ // 用不上
//            NSLog(@"");
//        }else if ([info isKindOfClass:NSClassFromString(@"UIStatusBarBatteryItemView")]){ //  电池信息  未用上
//            NSLog(@"");
//        }else if ([info isKindOfClass:NSClassFromString(@"UIStatusBarIndicatorItemView")]){ // 用不上
//            NSLog(@"");
//        }else if ([info isKindOfClass:NSClassFromString(@"UIStatusBarTimeItemView")]){ // 用不上  _timeString
//            NSLog(@"");
//        }else{
//            NSLog(@"");
//         }
//    }
    
//  http://developer.limneos.net/index.php?ios=10.2&framework=UIKit.framework&header=UIStatusBarBatteryItemView.h   这里可以查看 类的定义
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id info in infoArray){
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarBatteryPercentItemView")]){ // 百分比
            @try {
                return [info valueForKeyPath:@"percentString"];
            } @catch (NSException *exception) {
                return @"null";
            }
        }
    }
    return @"null";
}
- (NSString *)netInfo{
    NSString *netName = @"null";
    NSString *netType = @"null";
    NSString *netStrength = @"";
    NSString *netBars = @"";
    NSString *wifiBars = @"";
    NSString *wifiStrength = @"";
    UIApplication *app = [UIApplication sharedApplication];
    if([[app valueForKeyPath:@"_statusBar"] isKindOfClass: NSClassFromString(@"UIStatusBar_Modern")]){ //iphoneX
        NSString *wifiEntry =[[[[app valueForKey:@"statusBar"] valueForKey:@"_statusBar"] valueForKey:@"_currentAggregatedData"] valueForKey:@"_wifiEntry"];
        @try {
            wifiBars = [wifiEntry valueForKey:@"_displayValue"];
        } @catch (NSException *exception) {
        }
    }else{
        NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
        for (id info in subviews) {
            if([info isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                @try {
                    wifiBars = [info valueForKey:@"_wifiStrengthBars"];
                } @catch (NSException *exception) {
                }
                @try {
                    wifiStrength = [NSString stringWithFormat:@"%@dBm",[info valueForKey:@"_wifiStrengthRaw"]];
                } @catch (NSException *exception) {
                }
                break;
            }
        }
    }
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id info in infoArray) {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarSignalStrengthItemView")]){
            @try {
                netStrength = [NSString stringWithFormat:@"%@dBm",[info valueForKey:@"_signalStrengthRaw"]];
            } @catch (NSException *exception) {
            }
            @try {
                netBars = [NSString stringWithFormat:@"%@",[info valueForKey:@"_signalStrengthBars"]];
            } @catch (NSException *exception) {
            }
        }
        
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            int networkType = 99;
            @try {
                networkType = [[info valueForKeyPath:@"_dataNetworkType"] intValue];
            } @catch (NSException *exception) {
            }
            switch (networkType) {
                case 0:
                    netType = @"NONE";
                    break;
                case 1:
                    netType = @"2G";
                    break;
                case 2:
                    netType = @"3G";
                    break;
                case 3:
                    netType = @"4G";
                    break;
                case 5:
                    netType = @"WIFI";
                    break;
            }
        }
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")]) {
            @try {
                netName = [info valueForKeyPath:@"_serviceString"];// 中国联通
            } @catch (NSException *exception) {
            }
        }
    }
    return [NSString stringWithFormat:@"netName:%@ netType:%@ netStrength:[raw:%@ bars:%@] wifiStrength:[raw:%@ bars:%@]",netName,netType,netStrength,netBars,wifiStrength,wifiBars];
}
- (NSString *)currentTime {
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id info in infoArray) {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarTimeItemView")]) {
            @try {
                return [info valueForKeyPath:@"_timeString"];
            } @catch (NSException *exception) {
                return @"null";
            }
        }
    }
    return @"null";
}




#pragma mark disk
- (unsigned long long)getTotalDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
}

- (unsigned long long)getFreeDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}

#pragma mark cpu
- (NSString*)cpuUsed {
    kern_return_t           kr;
    thread_array_t          thread_list;
    mach_msg_type_number_t  thread_count;
    thread_info_data_t      thinfo;
    mach_msg_type_number_t  thread_info_count;
    thread_basic_info_t     basic_info_th;
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return @"-1";
    }
    float cpu_usage = 0;
    
    for (int i = 0; i < thread_count; i++){
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return @"-1";
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            cpu_usage += basic_info_th->cpu_usage;
        }
    }
    cpu_usage = cpu_usage / (float)TH_USAGE_SCALE * 100.0;
    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    return  [NSString stringWithFormat:@"%.2lf%%",cpu_usage];
}
- (NSString *)cpuType {
    return [self stringFromCpuType:[self getCpuType]];
}
- (NSInteger)getCpuType {
    return (NSInteger)(NXGetLocalArchInfo()->cputype);
}
- (NSString *)stringFromCpuType:(NSInteger)cpuType {
    switch (cpuType) {
        case CPU_TYPE_VAX:          return @"VAX";
        case CPU_TYPE_MC680x0:      return @"MC680x0";
        case CPU_TYPE_X86:          return @"X86";
        case CPU_TYPE_X86_64:       return @"X86_64";
        case CPU_TYPE_MC98000:      return @"MC98000";
        case CPU_TYPE_HPPA:         return @"HPPA";
        case CPU_TYPE_ARM:          return @"ARM";
        case CPU_TYPE_ARM64:        return @"ARM64";
        case CPU_TYPE_MC88000:      return @"MC88000";
        case CPU_TYPE_SPARC:        return @"SPARC";
        case CPU_TYPE_I860:         return @"I860";
        case CPU_TYPE_POWERPC:      return @"POWERPC";
        case CPU_TYPE_POWERPC64:    return @"POWERPC64";
        default:                    return @"Unknown";
    }
}

#pragma mark - 内存
- (NSString *)appUsedMemory{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return [NSString stringWithFormat:@"%.2lfMb",memoryUsageInByte/(1024*1024.0)];
    } else {
        return @"-1";
    }
}
- (NSString *)totalMemory{
    return [NSString stringWithFormat:@"%.2lfMb",[NSProcessInfo processInfo].physicalMemory/(1024*1024.0)];
}

#pragma mark - Disk
- (NSString *)totalDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    unsigned long long dis =  [[fattributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
    return [NSString stringWithFormat:@"%.2lfGb",dis/(1024*1024.0*1024.0)];
}
- (NSString *)freeDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    unsigned long long dis = [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    return [NSString stringWithFormat:@"%.2lfGb",dis/(1024*1024.0*1024.0)];
}

#pragma mark - Jailbreak

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])
- (int)jailBreak {
    BOOL isJailbreak = [MKDevice isJailBreak1] || [MKDevice isJailBreak2] || [MKDevice isJailBreak3] || [MKDevice isJailBreak4]  || [MKDevice isJailBreak6];
    return isJailbreak?2:0;
}
const char* mk_jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Applications/limera1n.app",
    "/Applications/greenpois0n.app",
    "/Applications/blackra1n.app",
    "/Applications/blacksn0w.app",
    "/Applications/redsn0w.app",
    "/Applications/Absinthe.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt",
    "/private/var/lib/apt/",
    NULL,
};
+ (BOOL)isJailBreak1 {
    BOOL exist = NO;
    for (int i=0; i<ARRAY_SIZE(mk_jailbreak_tool_pathes); i++) {
        @try {
            exist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:mk_jailbreak_tool_pathes[i]]];
        } @catch (NSException *exception) {
        }
        if(exist){
            return YES;
        }
    }
    return exist;
}
+ (BOOL)isJailBreak2 {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isJailBreak3 {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        return YES;
    }
    return NO;
}
+ (BOOL)isJailBreak4 {
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        return YES;
    }
    return NO;
}
+ (BOOL)isJailBreak5 { // 不准确  可能会利用 Fishhook原理 hook了stat
    int ret ;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        NSLog(@"lib :%s", dylib_info.dli_fname);
        return YES;
    }
    return NO;
}
char* printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    return env;
}
+ (BOOL)isJailBreak6 {
    if (printEnv()) {
        return YES;
    }
    return NO;
}



#pragma mark -
- (NSString *)deviceInfo {
    return [NSString stringWithFormat:
            @" appName: %@\n appVersion: %@\n appBundleVersion: %@\n deviceName: %@\n deviceModel: %@\n deviceVersion: %@\n deviceLanguage: %@\n batteryPercent: %@\n netInfo: %@\n currentTime: %@\n cpuType: %@\n cpuUsed: %@\n usedMemory: %@\n totalMemory: %@\n freedisk: %@\n totalDisk: %@\n jailBreak:%@",
            self.appName,self.appVersion,self.appBundleVersion,self.deviceName,self.deviceModel,self.deviceVersion,self.deviceLanguage,self.batteryPercent,self.netInfo,self.currentTime,
            self.cpuType,self.cpuUsed,self.appUsedMemory,self.totalMemory,self.freeDisk,self.totalDisk,self.jailBreak==2?@"true":@"false"];
}
-(NSString*) description {
    return self.deviceInfo;
}

- (NSDictionary *)modelDic{
    return @{@"x86_64":@"Simulator",
             @"i386":@"Simulator",
             
             
             @"iPod1,1":@"iPod Touch 1st Gen",
             @"iPod2,1":@"iPod Touch 2nd Gen",
             @"iPod3,1":@"iPod Touch 3rd Gen",
             @"iPod4,1":@"iPod Touch 4th Gen",
             @"iPod5,1":@"iPod Touch 5th Gen",
             @"iPod7,1":@"iPod Touch 6th Gen",
             
             
             @"iPhone1,1":@"iPhone",
             @"iPhone1,2":@"iPhone 3G",
             @"iPhone2,1":@"iPhone 3GS",
             @"iPhone3,1":@"iPhone 4",
             @"iPhone3,2":@"iPhone 4",
             @"iPhone3,3":@"iPhone 4",
             @"iPhone4,1":@"iPhone 4s",
             @"iPhone5,1":@"iPhone 5 model A1428",
             @"iPhone5,2":@"iPhone 5 model A1429",
             @"iPhone5,3":@"iPhone 5C",
             @"iPhone5,4":@"iPhone 5C",
             
             @"iPhone6,1":@"iPhone 5S",
             @"iPhone6,2":@"iPhone 5S",
             
             @"iPhone7,1":@"iPhone 6 Plus",
             @"iPhone7,2":@"iPhone 6",
             
             @"iPhone8,1":@"iPhone 6S",
             @"iPhone8,2":@"iPhone 6S Plus",
             @"iPhone8,4":@"iPhone SE",
             
             @"iPhone9,1":@"iPhone 7",
             @"iPhone9,2":@"iPhone 7 Plus",
             @"iPhone9,3":@"iPhone 7",
             @"iPhone9,4":@"iPhone 7 Plus",
             
             @"iPhone10,1":@"iPhone 8",
             @"iPhone10,2":@"iPhone 8 Plus",
             @"iPhone10,3":@"iPhone X",
             @"iPhone10,4":@"iPhone 8",
             @"iPhone10,5":@"iPhone 8 Plus",
             @"iPhone10,6":@"iPhone X",
             
             @"iPhone11,2":@"iPhone XS",
             @"iPhone11,4":@"iPhone XS Max",
             @"iPhone11,6":@"iPhone XS Max",
             @"iPhone11,8":@"iPhone XR",
             
             @"iPad1,1":@"iPad",
             @"iPad2,1":@"iPad 2 (Wi-Fi)",
             @"iPad2,2":@"iPad 2 (GSM)",
             @"iPad2,3":@"iPad 2 (CDMA)",
             @"iPad2,4":@"iPad 2 (Wi-Fi, revised)",
             @"iPad2,5":@"iPad mini (Wi-Fi)",
             @"iPad2,6":@"iPad mini (A1454)",
             @"iPad2,7":@"iPad mini (A1455)",
             @"iPad3,1":@"iPad (3rd gen, Wi-Fi)",
             @"iPad3,2":@"iPad (3rd gen, Wi-Fi+LTE Verizon)",
             @"iPad3,3":@"iPad (3rd gen, Wi-Fi+LTE AT&T)",
             @"iPad3,4":@"iPad (4th gen, Wi-Fi)",
             @"iPad3,5":@"iPad (4th gen, A1459)",
             @"iPad3,6":@"iPad (4th gen, A1460)",
             @"iPad4,1":@"iPad Air (Wi-Fi)",
             @"iPad4,2":@"iPad Air (Wi-Fi+LTE)",
             @"iPad4,3":@"iPad Air (Rev)",
             @"iPad4,4":@"iPad mini 2 (Wi-Fi)",
             @"iPad4,5":@"iPad mini 2 (Wi-Fi+LTE)",
             @"iPad4,6":@"iPad mini 2 (Rev)",
             @"iPad4,7":@"iPad mini 3 (Wi-Fi)",
             @"iPad4,8":@"iPad mini 3 (A1600)",
             @"iPad4,9":@"iPad mini 3 (A1601)",
             @"iPad5,1":@"iPad mini 4 (Wi-Fi)",
             @"iPad5,2":@"iPad mini 4 (Wi-Fi+LTE)",
             @"iPad5,3":@"iPad Air 2 (Wi-Fi)",
             @"iPad5,4":@"iPad Air 2 (Wi-Fi+LTE)",
             @"iPad6,3":@"iPad Pro (9.7 inch) (Wi-Fi)",
             @"iPad6,4":@"iPad Pro (9.7 inch) (Wi-Fi+LTE)",
             @"iPad6,7":@"iPad Pro (12.9 inch, Wi-Fi)",
             @"iPad6,8":@"iPad Pro (12.9 inch, Wi-Fi+LTE)",
             @"iPod1,1":@"iPod touch",
             @"iPod2,1":@"iPod touch (2nd gen)",
             @"iPod3,1":@"iPod touch (3rd gen)",
             @"iPod4,1":@"iPod touch (4th gen)",
             @"iPod5,1":@"iPod touch (5th gen)",
             @"iPod7,1":@"iPod touch (6th gen)",
             @"iPad6,11":@"iPad 5",
             @"iPad6,12":@"iPad 5",
             @"iPad7,1":@"iPad Pro (12.9 inch, 2nd gen)",
             @"iPad7,2":@"iPad Pro (12.9 inch, 2nd gen)",
             @"iPad7,3":@"iPad Pro (10.5 inch)",
             @"iPad7,4":@"iPad Pro (10.5 inch)",
             @"iPad8,1":@"iPad Pro 11 inch",
             @"iPad8,2":@"iPad Pro 11 inch",
             @"iPad8,3":@"iPad Pro 11 inch",
             @"iPad8,4":@"iPad Pro 11 inch",
             @"iPad8,5":@"iPad Pro 12.9 inch 3rd Gen",
             @"iPad8,6":@"iPad Pro 12.9 inch 3rd Gen",
             @"iPad8,7":@"iPad Pro 12.9 inch 3rd Gen",
             @"iPad8,8":@"iPad Pro 12.9 inch 3rd Gen",
             };
}

@end
