//
//  LYZLocationHelper.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/29.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZLocationHelper.h"

@interface LYZLocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LYZLocationHelper

#pragma mark - life cycle

IS_SINGLETON(LYZLocationHelper)

#pragma maek - public method

- (void)startLocation
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - override super

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *recentLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:recentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            if ([self.delegate respondsToSelector:@selector(locationHelper:didSuccess:)]) {
                [self.delegate locationHelper:self didSuccess:placemarks];
            }
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        if ([self.delegate respondsToSelector:@selector(locationHelperDidClose:)]) {
            [self.delegate locationHelperDidClose:self];
        }
    } if ([error code] == kCLErrorLocationUnknown) {
        if ([self.delegate respondsToSelector:@selector(locationHelper:didFailed:)]) {
            [self.delegate locationHelper:self didFailed:error];
        }
    }
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        if ([LYZDeviceInfo systemVersionGreaterThanOrEqualTo:@"8.0"]) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] ? YES : NO;
            BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] ? YES : NO;
            if (hasAlwaysKey) {
                [self.locationManager requestAlwaysAuthorization];
            }
            else if (hasWhenInUseKey) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            else {
                NSAssert(hasAlwaysKey || hasWhenInUseKey, @"In iOS 8+, Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
            }
        }
    }
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (CLLocationManager *)locationManager
{
    if (! _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 定位精度
        _locationManager.distanceFilter = 10; // 距离过滤器
    }
    return _locationManager;
}

@end
