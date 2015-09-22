//
//  LYZDeviceInfo.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/18.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYZDeviceInfo : NSObject

#pragma mark - LYZDeviceInfo public

/** @return e.g. "My iPhone" */
+ (NSString *)deviceName;
/** @return e.g. @"iPhone" @"iPod touch" */
+ (NSString *)deviceModel;

#pragma mark -

/** @return e.g. @"iOS" */
+ (NSString *)systemName;
/** @return e.g. @"7.0" */
+ (NSString *)systemVersion;
/** e.g. == @"7.0" */
+ (BOOL)systemVersionEqualTo:(NSString *)version;
/** e.g. >  @"7.0" *///
+ (BOOL)systemVersionGreaterThan:(NSString *)version;
/** e.g. >= @"7.0" *///
+ (BOOL)systemVersionGreaterThanOrEqualTo:(NSString *)version;
/** e.g. <  @"7.0" *///
+ (BOOL)systemVersionLessThan:(NSString *)version;
/** e.g. <= @"7.0" *///
+ (BOOL)systemVersionLessThanOrEqualTo:(NSString *)version;

#pragma mark -

/** @return e.g. @"iPhone6,1" */
+ (NSString *)deviceTag;
/** @return e.g. @"iPhone 5S" */
+ (NSString *)deviceType;
/** @return e.g. (640, 1136) */
+ (CGSize)sizeInPixel;
/** @return e.g. 326 */
+ (CGFloat)pixelsPerInch;
/** 获取设备UUID */
+ (NSString *)deviceUUID;

#pragma mark -

+ (BOOL)isPhone;
+ (BOOL)isPad;
+ (BOOL)isSimulator;
+ (BOOL)isRetina;

@end
