//
//  LYZHardwareAvailable.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/22.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYZHardwareAvailable : NSObject

#pragma mark - LYZHardwareAvailable public

/** 麦克风 */
+ (BOOL)microphoneAvailable;

#pragma mark -

/** 后置摄像头 */
+ (BOOL)cameraAvailable;
/** 前置摄像头 */
+ (BOOL)cameraFrontAvailable;
/** 视频录制 */
+ (BOOL)cameraVideoAvailable;
/** 闪光灯 */
+ (BOOL)cameraFlashAvailable;

#pragma mark -

/** 指南针 */
+ (BOOL)compassAvailable;
/** 陀螺仪 */
+ (BOOL)gyroscopeAvailable;

#pragma mark -

/** 拨打电话 */
+ (BOOL)phoneCallsAvailable;
/** 多任务 */
+ (BOOL)multitaskingAvailable;
/** 指纹识别 */
+ (BOOL)touchIdAvailable;

@end
