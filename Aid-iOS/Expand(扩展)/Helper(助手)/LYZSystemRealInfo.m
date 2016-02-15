//
//  LYZSystemRealInfo.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <sys/sysctl.h>
#import <mach/mach.h>

#import "LYZSystemRealInfo.h"
#import "LYZMathMacro.h"

@implementation LYZSystemRealInfo

#pragma mark - LYZSystemRealInfo public

+ (CGFloat)MBytesOfMemoryTotal
{
    return [self getSysInfo:HW_PHYSMEM] / LYZMBInBytes;
}

+ (CGFloat)MBytesOfMemoryUser
{
    return [self getSysInfo:HW_USERMEM] / LYZMBInBytes;
}

#pragma mark -

+ (CGFloat)GBytesOfDiskSpaceTotal
{
    NSDictionary *sFileSystem = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber* totalSize = [sFileSystem objectForKey:NSFileSystemSize];
    
    return  totalSize.doubleValue / LYZGBInBytes;
}

+ (CGFloat)GBytesOfDiskSpaceFree
{
    NSDictionary *sFileSystem = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber* freeSize = [sFileSystem objectForKey:NSFileSystemFreeSize];
    
    return freeSize.doubleValue / LYZGBInBytes;
}

+ (CGFloat)GBytesOfDiskSpaceUsed
{
    CGFloat total = [self GBytesOfDiskSpaceTotal];
    CGFloat free = [self GBytesOfDiskSpaceFree];
    
    return total - free;
}

#pragma mark -

+ (NSUInteger)cpuCount
{
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (CGFloat)cpuUsage
{
    CGFloat cpu = 0.0f;
    NSArray *cpus = [self cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    
    return cpu;
}

#pragma mark -

+ (CGFloat)batteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat battery = [[UIDevice currentDevice] batteryLevel];
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    
    return battery;
}

+ (UIDeviceBatteryState)batteryState
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    
    return state;
}

#pragma mark -

+ (CGFloat)screenBrightness
{
    return [UIScreen mainScreen].brightness;
}

#pragma mark -

+ (NSTimeInterval)systemUptime
{
    return [NSProcessInfo processInfo].systemUptime;
}

#pragma mark - LYZDeviceInfo helper

+ (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    int mib[2] = {CTL_HW, typeSpecifier};
    int results;
    size_t size = sizeof(int);
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger)results;
}

+ (NSArray *)cpuUsagePerProcessor
{
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray array];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return [cpus copy];
    }
    else {
        return nil;
    }
}

@end
