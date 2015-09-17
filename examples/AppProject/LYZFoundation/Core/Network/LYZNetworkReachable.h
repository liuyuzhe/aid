//
//  LYZNetworkReachable.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LYZNetworkReachableNotReachableNotification;
extern NSString * const LYZNetworkReachableWiFiReachableNotification;
extern NSString * const LYZNetworkReachableWWANReachableNotification;
extern NSString * const LYZNetworkReachableChangedReachableNotification;

typedef NS_ENUM(NSInteger, LYZNetworkState)
{
    LYZNetworkStateOtherWWAN = -1,
    LYZNetworkStateWithout = 0,
    LYZNetworkStateWifi = 1,
    LYZNetworkState2G = 2,
    LYZNetworkState3G = 3,
    LYZNetworkState4G = 4,
};


@interface LYZNetworkReachable : NSObject

+ (LYZNetworkState)currentNetworkState;
+ (BOOL)isWifiNetwork;
+ (BOOL)isWWANNetwork;
+ (BOOL)isWithoutNetwork;

/** 运营商名称 */
+ (NSString *)getCarrierName;
/** wifi网络名称 */
+ (NSString *)currentSSID;
/** e.g. "192.168.1.111" */
+ (NSString *)wifiIPAddress;
/** e.g. "10.2.2.222" */
+ (NSString *)WWANIPAddress;


@end
