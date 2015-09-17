//
//  LYZNetworkReachable.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

@import CoreTelephony;
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "LYZNetworkReachable.h"
#import "LYZSingletonMacro.h"
#import "Reachability.h"
#import "LYZDeviceInfo.h"

NSString * const LYZNetworkReachableNotReachableNotification =
    @"LYZNetworkReachable.NotReachable.Notification";
NSString * const LYZNetworkReachableWiFiReachableNotification =
    @"LYZNetworkReachable.WiFiReachable.Notification";
NSString * const LYZNetworkReachableWWANReachableNotification =
    @"LYZNetworkReachable.WWANReachable.Notification";
NSString * const LYZNetworkReachableChangedReachableNotification =
    @"LYZNetworkReachable.ChangedReachable.Notification";

@interface LYZNetworkReachable ()

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;

- (LYZNetworkState)currentNetworkState;
- (NSString *)getCarrierName;

@end


@implementation LYZNetworkReachable

IS_SINGLETON(LYZNetworkReachable)

#pragma mark - LYZNetworkReachable method

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleReachableChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        _reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
        [_reachability startNotifier];
        
        _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_reachability stopNotifier];
}

#pragma mark - LYZNetworkReachable public

+ (LYZNetworkState)currentNetworkState
{
    return [[[self class] sharedInstance] currentNetworkState];
}

+ (BOOL)isWifiNetwork;
{
    if ([self currentNetworkState] == LYZNetworkStateWifi) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isWWANNetwork
{
    BOOL isWWAN = NO;
    
    switch ([self currentNetworkState]) {
        case LYZNetworkStateOtherWWAN: {
            isWWAN = YES;
            break;
        }
        case LYZNetworkStateWithout: {
            isWWAN = NO;
            break;
        }
        case LYZNetworkStateWifi: {
            isWWAN = NO;
            break;
        }
        case LYZNetworkState2G: {
            isWWAN = YES;
            break;
        }
        case LYZNetworkState3G: {
            isWWAN = YES;
            break;
        }
        case LYZNetworkState4G: {
            isWWAN = YES;
            break;
        }
        default: {
            break;
        }
    }
    
    return isWWAN;
}

+ (BOOL)isWithoutNetwork
{
    if ([self currentNetworkState] == LYZNetworkStateWithout) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)getCarrierName
{
    return [[[self class] sharedInstance] getCarrierName];
}

+ (NSString *)currentSSID
{
    __block NSString *ssid;
    
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    
    [ifs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *infos = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)obj);
        if ([infos objectForKey:@"SSID"])
        {
            ssid = [infos objectForKey:@"SSID"];
            *stop = YES;
        }
    }];
    
    return ssid;
}

+ (NSString *)wifiIPAddress
{
    NSString *IPAddress = @"127.0.0.1";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    if (getifaddrs(&interfaces) == 0) {
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    IPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return IPAddress;
}

+ (NSString *)WWANIPAddress
{
    NSString *IPAddress;
    
    struct ifaddrs *interfaces;
    struct ifaddrs *temp_addr;
    struct sockaddr_in *s4;
    char buf[64];
    
    if (getifaddrs(&interfaces) == 0) {
        temp_addr = interfaces;
        
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    s4 = (struct sockaddr_in *)temp_addr->ifa_addr;
                    if (inet_ntop(temp_addr->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) != NULL) {
                        IPAddress = [NSString stringWithUTF8String:buf];
                    }
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return IPAddress;
}

#pragma mark - LYZNetworkReachable private

- (LYZNetworkState)currentNetworkState
{
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        return LYZNetworkStateWifi; // WIFI网络
    }
    else if ([self.reachability currentReachabilityStatus] == ReachableViaWWAN) {
        return [self getNetworkWWAN]; // WWAN网络
    }
    else {
        return LYZNetworkStateWithout; // 没有网络
    }
}

- (NSString *)getCarrierName
{
    return self.networkInfo.subscriberCellularProvider.carrierName;
}

#pragma mark - LYZNetworkReachable helper

- (LYZNetworkState)getNetworkWWAN
{
    if ([LYZDeviceInfo systemVersionGreaterThanOrEqualTo:@"7.0"]) {
        NSString *currentStatus  = self.networkInfo.currentRadioAccessTechnology;
        
        if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]){
            return LYZNetworkState2G; // 移动/联通GPRS 2G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]){
            return LYZNetworkState2G; // 移动/联通E网 2G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
            return LYZNetworkState3G; // WCDMA 3G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
            return LYZNetworkState3G; // 移动/联通 3G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
            return LYZNetworkState3G; // 移动/联通 3G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
            return LYZNetworkState2G; // 电信CDMA 2G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
            return LYZNetworkState3G; // 电信Rev0 3G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
            return LYZNetworkState3G; // 电信RevA 3G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
            return LYZNetworkState3G; // 电信RevB 3G网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
            return LYZNetworkState3G; // CDMA 网络
        }
        else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
            return LYZNetworkState4G; // LTE 4G网络
        }
    }
    
    return LYZNetworkStateOtherWWAN;
}

#pragma mark - NSNotification event

- (void)handleReachableChanged:(NSNotification *)note
{
    Reachability* reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    
    NetworkStatus newStatus = [reach currentReachabilityStatus];
    if (newStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LYZNetworkReachableNotReachableNotification object:nil];
    }
    else if (newStatus == ReachableViaWiFi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LYZNetworkReachableWiFiReachableNotification object:nil];
    }
    else if (newStatus == ReachableViaWWAN) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LYZNetworkReachableWWANReachableNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LYZNetworkReachableChangedReachableNotification object:nil];
}

@end
