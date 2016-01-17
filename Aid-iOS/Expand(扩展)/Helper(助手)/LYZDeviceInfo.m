//
//  LYZDeviceInfo.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/18.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <sys/utsname.h>

#import "LYZDeviceInfo.h"

@implementation LYZDeviceInfo

#pragma mark - LYZDeviceInfo public

+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}

+ (NSString *)deviceModel
{
    return [UIDevice currentDevice].model;
}

+ (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}
#pragma mark -

+ (NSString *)systemName
{
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (BOOL)systemVersionEqualTo:(NSString *)version
{
    return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame;
}

+ (BOOL)systemVersionGreaterThan:(NSString *)version
{
    return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending;
}

+ (BOOL)systemVersionGreaterThanOrEqualTo:(NSString *)version
{
    return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending;
}

+ (BOOL)systemVersionLessThan:(NSString *)version
{
    return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending;
}

+ (BOOL)systemVersionLessThanOrEqualTo:(NSString *)version
{
    return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending;
}

#pragma mark -

+ (NSString *)deviceTag;
{
    struct utsname UTS;
    uname(&UTS);
    
    return [NSString stringWithFormat:@"%s", UTS.machine];
}

+ (NSString *)deviceType;
{
    NSString *deviceModel = @"Unknown device";

    NSString *tag = [self deviceTag];
    
    if ([tag isEqualToString:@"i386"] || [tag isEqualToString:@"x86_64"]) {
        deviceModel = @"IOS Simulator";
    }
    // iPhone
    else if ([tag hasPrefix:@"iPhone"]) {
        if ([tag isEqualToString:@"iPhone7,1"] || [tag isEqualToString:@"iPhone7,1*"]) {
            deviceModel = @"iPhone 6 Plus";
        }
        else if ([tag isEqualToString:@"iPhone7,2"] || [tag isEqualToString:@"iPhone7,2*"]) {
            deviceModel = @"iPhone 6";
        }
        else if ([tag isEqualToString:@"iPhone6,1"] || [tag isEqualToString:@"iPhone6,2"]) {
            deviceModel = @"iPhone 5S";
        }
        else if ([tag isEqualToString:@"iPhone5,1"] || [tag isEqualToString:@"iPhone5,2"]) {
            deviceModel = @"iPhone 5";
        }
        else if ([tag isEqualToString:@"iPhone5,3"] || [tag isEqualToString:@"iPhone5,4"]) {
            deviceModel = @"iPhone 5C";
        }
        else if ([tag isEqualToString:@"iPhone4,1"] || [tag isEqualToString:@"iPhone4,1*"]) {
            deviceModel = @"iPhone 4S";
        }
        else if ([tag isEqualToString:@"iPhone3,1"]) {
            deviceModel = @"iPhone 4";
        }
        else if ([tag isEqualToString:@"iPhone2,1"] || [tag isEqualToString:@"iPhone2,1*"]) {
            deviceModel = @"iPhone 3GS";
        }
        else if ([tag isEqualToString:@"iPhone1,2"] || [tag isEqualToString:@"iPhone1,2*"]) {
            deviceModel = @"iPhone 3G";
        }
        else if ([tag isEqualToString:@"iPhone1,1"]) {
            deviceModel = @"iPhone";
        }
        else {
            deviceModel = @"iPhone";
        }
    }
    // iPad
    else if ([tag hasPrefix:@"iPad"]) {
        if ([tag isEqualToString:@"iPad5,3"] || [tag isEqualToString:@"iPad5,4"]) {
            deviceModel = @"iPad Air 2";
        }
        else if ([tag isEqualToString:@"iPad4,7"] || [tag isEqualToString:@"iPad4,8"]) {
            deviceModel = @"iPad Mini 3";
        }
        else if ([tag isEqualToString:@"iPad4,4"] || [tag isEqualToString:@"iPad4,5"] || [tag isEqualToString:@"iPad4,6"]) {
            deviceModel = @"iPad Mini 2";
        }
        else if ([tag isEqualToString:@"iPad4,1"] || [tag isEqualToString:@"iPad4,2"] || [tag isEqualToString:@"iPad4,3"]) {
            deviceModel = @"iPad Air";
        }
        else if ([tag isEqualToString:@"iPad3,4"] || [tag isEqualToString:@"iPad3,5"] || [tag isEqualToString:@"iPad3,6"]) {
            deviceModel = @"iPad 4";
        }
        else if ([tag isEqualToString:@"iPad3,1"] || [tag isEqualToString:@"iPad3,2"] || [tag isEqualToString:@"iPad3,3"]) {
            deviceModel = @"iPad 3";
        }
        else if ([tag isEqualToString:@"iPad2,1"] || [tag isEqualToString:@"iPad2,2"] || [tag isEqualToString:@"iPad2,3"] || [tag isEqualToString:@"iPad2,4"]) {
            deviceModel = @"iPad 2";
        }
        else if ([tag isEqualToString:@"iPad2,5"] || [tag isEqualToString:@"iPad2,6"] || [tag isEqualToString:@"iPad2,7"]) {
            deviceModel = @"iPad Mini";
        }
        else if ([tag isEqualToString:@"iPad1,1"] || [tag isEqualToString:@"iPad1,2"]) {
            deviceModel = @"iPad";
        }
        else {
            deviceModel = @"iPad";
        }
    }
    // iPod
    else if ([tag hasPrefix:@"iPod"])
    {
        if ([tag isEqualToString:@"iPod5,1"]) {
            deviceModel = @"iPod Touch 5";
        }
        else if ([tag isEqualToString:@"iPod4,1"]) {
            deviceModel = @"iPod Touch 4";
        }
        else if ([tag isEqualToString:@"iPod3,1"]) {
            deviceModel = @"iPod Touch 3";
        }
        else if ([tag isEqualToString:@"iPod2,1"]) {
            deviceModel = @"iPod Touch 2";
        }
        else if ([tag isEqualToString:@"iPod1,1"]) {
            deviceModel = @"iPod Touch 1";
        }
        else {
            deviceModel = @"iPod";
        }
    }
    
    return deviceModel;
}

+ (CGSize)sizeInPixel
{
    CGSize size = CGSizeZero;
    
    NSString *tag = [self deviceTag];
    if ([tag hasPrefix:@"iPhone"]) {
        if ([tag hasPrefix:@"iPhone1"] || [tag hasPrefix:@"iPhone2"]) {
            size = CGSizeMake(320, 480);
        }
        else if ([tag hasPrefix:@"iPhone3"] || [tag hasPrefix:@"iPhone4"]) {
            size = CGSizeMake(640, 960);
        }
        else if ([tag hasPrefix:@"iPhone5"] || [tag hasPrefix:@"iPhone6"]) {
            size = CGSizeMake(640, 1136);
        }
        else if ([tag hasPrefix:@"iPhone7,1"]) {
            size = CGSizeMake(1080, 1920);
        }
        else if ([tag hasPrefix:@"iPhone7,2"]) {
            size = CGSizeMake(750, 1334);
        }
    }
    else if ([tag hasPrefix:@"iPad"]) {
        if ([tag hasPrefix:@"iPad1"] || [tag hasPrefix:@"iPad2"])
            size = CGSizeMake(768, 1024);
        else if ([tag hasPrefix:@"iPad3"] || [tag hasPrefix:@"iPad4"] || [tag hasPrefix:@"iPad5"]) {
            size = CGSizeMake(1536, 2048);
        }
    }
    else if ([tag hasPrefix:@"iPod"]) {
        if ([tag hasPrefix:@"iPod1"] || [tag hasPrefix:@"iPod2"] || [tag hasPrefix:@"iPod3"]) {
            size = CGSizeMake(320, 480);
        }
        else if ([tag hasPrefix:@"iPod4"]) {
            size = CGSizeMake(640, 960);
        }
        else if ([tag hasPrefix:@"iPod5"]) {
            size = CGSizeMake(640, 1136);
        }
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]) {
            size = [UIScreen mainScreen].nativeBounds.size;
        } else {
            size = [UIScreen mainScreen].bounds.size;
            size.width *= [UIScreen mainScreen].scale;
            size.height *= [UIScreen mainScreen].scale;
        }
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    }
    
    return size;
}

+ (CGFloat)pixelsPerInch
{
    CGFloat ppi = 0;
    
    NSString *tag = [self deviceTag];
    if ([tag hasPrefix:@"iPhone"]) {
        if ([tag hasPrefix:@"iPhone7,2"]) {
            ppi = 326;
        }
        else if ([tag hasPrefix:@"iPhone7,1"]) {
            ppi = 401;
        }
        else if ([tag hasPrefix:@"iPhone3"] || [tag hasPrefix:@"iPhone4"] || [tag hasPrefix:@"iPhone5"] || [tag hasPrefix:@"iPhone6"]) {
            ppi = 326;
        }
        else if ([tag hasPrefix:@"iPhone1"] || [tag hasPrefix:@"iPhone2"]) {
            ppi = 163;
        }
    }
    else if ([tag hasPrefix:@"iPod"]) {
        if ([tag hasPrefix:@"iPod5"]) {
            ppi = 326;
        }
        else if ([tag hasPrefix:@"iPod4"]) {
            ppi = 326;
        }
        else if ([tag hasPrefix:@"iPod1"] || [tag hasPrefix:@"iPod2"] || [tag hasPrefix:@"iPod3"]) {
            ppi = 163;
        }
    }
    else if ([tag hasPrefix:@"iPad"]) {
        if ([tag hasPrefix:@"iPad4,4"] || [tag hasPrefix:@"iPad4,5"] || [tag hasPrefix:@"iPad4,6"] || [tag hasPrefix:@"iPad4,7"] || [tag hasPrefix:@"iPad4,8"] || [tag hasPrefix:@"iPad4,9"] || [tag hasPrefix:@"iPad5,4"]) {
            ppi = 324;
        }
        else if ([tag hasPrefix:@"iPad3"] || [tag hasPrefix:@"iPad4,1"] || [tag hasPrefix:@"iPad4,2"] || [tag hasPrefix:@"iPad4,3"] || [tag hasPrefix:@"iPad5,3"]) {
            ppi = 264;
        }
        else if ([tag hasPrefix:@"iPad2,5"] || [tag hasPrefix:@"iPad2,6"] || [tag hasPrefix:@"iPad2,7"]) {
            ppi = 163;
        }
        else if ([tag hasPrefix:@"iPad1"] || [tag hasPrefix:@"iPad2,1"] || [tag hasPrefix:@"iPad2,2"] || [tag hasPrefix:@"iPad2,3"] || [tag hasPrefix:@"iPad2,4"]) {
            ppi = 132;
        }
    }
    
    if (ppi == 0) {
        ppi = 96;
    }
    
    return ppi;
}

+ (NSString *)deviceUUID
{
    static NSString *uuid = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    });
    return uuid;
}

#pragma mark -

+ (BOOL)isPhone
{
    static BOOL isPhone = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    });
    
    return isPhone;
}

+ (BOOL)isPad
{
    static BOOL isPad = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    });
    
    return isPad;
}

+ (BOOL)isSimulator;
{
    static BOOL isSimu = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isSimu = ([[UIDevice currentDevice].model rangeOfString:@"Simulator"].location != NSNotFound);
    });
    return isSimu;
}

+ (BOOL)isRetina
{
    return [UIScreen mainScreen].scale > 1.0f;
}

@end
