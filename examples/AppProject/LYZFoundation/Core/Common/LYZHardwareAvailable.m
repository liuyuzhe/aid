//
//  LYZHardwareAvailable.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/22.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

@import AVFoundation;
@import MobileCoreServices;
@import CoreLocation;
@import CoreMotion;
@import LocalAuthentication;
#import <UIKit/UIKit.h>

#import "LYZHardwareAvailable.h"

@implementation LYZHardwareAvailable

#pragma mark - LYZHardwareAvailable public

+ (BOOL)microphoneAvailable
{
    return [AVAudioSession sharedInstance].inputAvailable;
}

#pragma mark -

+ (BOOL)cameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)cameraFrontAvailable
{
    return[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)cameraVideoAvailable
{
    if(! [self cameraAvailable]) {
        return NO;
    }
    
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([sourceTypes containsObject:(NSString *)kUTTypeMovie]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)cameraFlashAvailable
{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark -

+ (BOOL)compassAvailable
{
    return [CLLocationManager headingAvailable];
}

+ (BOOL)gyroscopeAvailable
{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    return motionManager.gyroAvailable;
}

#pragma mark -

+ (BOOL)phoneCallsAvailable
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

+ (BOOL)multitaskingAvailable
{
    return [UIDevice currentDevice].multitaskingSupported;
}

+ (BOOL)touchIdAvailable
{
    LAContext *context = [[LAContext alloc] init];
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

@end
