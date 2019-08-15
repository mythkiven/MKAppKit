/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKMemoryHelper.h"
#include <mach/mach.h>
#include <malloc/malloc.h>

static vm_size_t            jPageSize = 0;
static vm_statistics_data_t jVMStats;

@implementation MKMemoryHelper

#warning 【todo】【较为精确的计算，已使用的内存】
// http://www.samirchen.com/ios-app-memory-usage/ 提到的使用 phys_footprint值，待验证。
+ (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}


+ (unsigned long long)bytesOfUsedMemory
{
    struct mstats stat = mstats();
    return  stat.bytes_used;
}

//+ (unsigned long long)bytesOfFreeMemory
//{
//    return NSRealMemoryAvailable();
//}

+ (unsigned long long)bytesOfTotalMemory
{
    [self updateHostStatistics];
    
    unsigned long long free_count   = (unsigned long long)jVMStats.free_count;
    unsigned long long active_count = (unsigned long long)jVMStats.active_count;
    unsigned long long inactive_count = (unsigned long long)jVMStats.inactive_count;
    unsigned long long wire_count =  (unsigned long long)jVMStats.wire_count;
    unsigned long long pageSize = (unsigned long long)jPageSize;
    
    unsigned long long mem_free = (free_count + active_count + inactive_count + wire_count) * pageSize;
    return mem_free;
}

//for internal use
+ (BOOL)updateHostStatistics {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &jPageSize);
    return (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&jVMStats, &host_size)
            == KERN_SUCCESS);
}
@end
