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

/** 麦克风是否可用 */
+ (BOOL)microphoneAvailable;

#pragma mark -

/** 后置摄像头是否可用 */
+ (BOOL)cameraAvailable;
/** 前置摄像头是否可用 */
+ (BOOL)cameraFrontAvailable;
/** 视频录制是否可用 */
+ (BOOL)cameraVideoAvailable;
/** 闪光灯是否可用 */
+ (BOOL)cameraFlashAvailable;

#pragma mark -

/** 指南针是否可用 */
+ (BOOL)compassAvailable;
/** 陀螺仪是否可用 */
+ (BOOL)gyroscopeAvailable;

#pragma mark -

/** 拨打电话是否可用 */
+ (BOOL)phoneCallsAvailable;
/** 多任务是否可用 */
+ (BOOL)multitaskingAvailable;
/** 指纹识别是否可用 */
+ (BOOL)touchIdAvailable;

@end
