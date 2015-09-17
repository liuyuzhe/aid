//
//  LYZPerformanceAnalyze.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mach/mach_time.h>

#import "LYZPerformanceAnalyze.h"

@implementation LYZPerformanceAnalyze

+ (CGFloat)timeCost:(dispatch_block_t)block
{
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        return -1.0;
    }
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    
    uint64_t elapsed = end - start;
    uint64_t nanos = elapsed * info.numer / info.denom;
    
    return (CGFloat)nanos / NSEC_PER_SEC;
}

@end
