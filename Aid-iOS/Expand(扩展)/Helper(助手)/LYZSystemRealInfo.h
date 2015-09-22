//
//  LYZSystemRealInfo.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYZSystemRealInfo : NSObject

#pragma mark - LYZSystemRealInfo public

/** 总内存 */
+ (CGFloat)MBytesOfMemoryTotal;
/** 已用内存 */
+ (CGFloat)MBytesOfMemoryUser;

#pragma mark -

/** 总磁盘 */
+ (CGFloat)GBytesOfDiskSpaceTotal;
/** 剩余磁盘 */
+ (CGFloat)GBytesOfDiskSpaceFree;
/** 已用磁盘 */
+ (CGFloat)GBytesOfDiskSpaceUsed;

#pragma mark -

/** CPU个数 */
+ (NSUInteger)cpuCount;
/** 已用CPU @return 0 .. 1.0 */
+ (CGFloat)cpuUsage;

#pragma mark -

/** 电池电量 @return 0 .. 1.0 */
+ (CGFloat)batteryLevel;
/** 电池状态 */
+ (UIDeviceBatteryState)batteryState;

#pragma mark -

/** 屏幕亮度 @return 0 .. 1.0 */
+ (CGFloat)screenBrightness;

#pragma mark -

/** 系统运行时间 */
+ (NSTimeInterval)systemUptime;

@end
