//
//  LYZLocationManager.m
//  AppProject
//
//  Created by 刘育哲 on 15/3/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZLocationManager.h"
#import "LYZLocationRequest.h"
#import "LYZDebugMacro.h"
#import "LYZDeviceInfo.h"

@interface LYZLocationManager () <CLLocationManagerDelegate, LYZLocationRequestDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, getter=currentLocation) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *locationRequests;
@property (nonatomic, assign) BOOL updateFailed;

- (void)addLocationRequest:(LYZLocationRequest *)locationRequest;
- (void)startUpdatingLocationIfNeeded;

@end


@implementation LYZLocationManager

IS_SINGLETON(LYZLocationManager)

#pragma mark - LYZLocationManager method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationRequests = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    _locationManager.delegate = nil;
}

#pragma mark - LYZLocationManager public

+ (LYZLocationServiceState)locationServiceState
{
    if (! [CLLocationManager locationServicesEnabled]) {
        return LYZLocationServiceStateDisabled;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return LYZLocationServiceStateNotDetermined;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return LYZLocationServiceStateRestricted;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return LYZLocationServiceStateDenied;
    }
    
    return LYZLocationServiceStateAvailable;
}

- (LYZLocationRequestID)requestLocationWithDesiredAccuracy:(LYZLocationAccuracy)desiredAccuracy
                            timeout:(NSTimeInterval)timeout
                              block:(LYZLocationRequestBlock)block
{
    return [self requestLocationWithDesiredAccuracy:desiredAccuracy
                                     timeout:timeout
                        delayUntilAuthorized:NO
                                       block:block];
}

- (LYZLocationRequestID)requestLocationWithDesiredAccuracy:(LYZLocationAccuracy)desiredAccuracy
                                   timeout:(NSTimeInterval)timeout
                      delayUntilAuthorized:(BOOL)delayUntilAuthorized
                                     block:(LYZLocationRequestBlock)block
{
    if (desiredAccuracy == LYZLocationAccuracyNone) {
        desiredAccuracy = LYZLocationAccuracyCity; // default
    }
    
    LYZLocationRequest *locationRequest = [[LYZLocationRequest alloc] init];
    locationRequest.delegate = self;
    locationRequest.desiredAccuracy = desiredAccuracy;
    locationRequest.timeout = timeout;
    locationRequest.block = block;
    
    BOOL delayTimeout = delayUntilAuthorized && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
    if (! delayTimeout) {
        [locationRequest startTimeoutTimerIfNeeded];
    }
    
    [self addLocationRequest:locationRequest];

    return locationRequest.requestID;
}

- (LYZLocationRequestID)subscribeToLocationUpdatesWithBlock:(LYZLocationRequestBlock)block
{
    LYZLocationRequest *locationRequest = [[LYZLocationRequest alloc] init];
    locationRequest.desiredAccuracy = LYZLocationAccuracyNone;
    locationRequest.block = block;
    
    [self addLocationRequest:locationRequest];

    return locationRequest.requestID;
}

- (void)cancelLocationRequest:(LYZLocationRequestID)requestID
{
    LYZLocationRequest *cancelLocationRequest;
    for (LYZLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            cancelLocationRequest = locationRequest;
            break;
        }
    }
    
    if (cancelLocationRequest) {
        [self.locationRequests removeObject:cancelLocationRequest];
        [cancelLocationRequest cancel];
        [self stopUpdatingLocationIfPossible];
    }
}

#pragma mark - LYZLocationManager private

- (void)addLocationRequest:(LYZLocationRequest *)locationRequest
{
    LYZLocationServiceState serviceState = [LYZLocationManager locationServiceState];
    if (serviceState == LYZLocationServiceStateDisabled ||
        serviceState == LYZLocationServiceStateDenied ||
        serviceState == LYZLocationServiceStateRestricted) {
        [self completeLocationRequest:locationRequest];
        return;
    }
    
    [self startUpdatingLocationIfNeeded];
    
    [self.locationRequests addObject:locationRequest];
}

- (void)startUpdatingLocationIfNeeded
{
    if ([LYZDeviceInfo systemVersionGreaterThanOrEqualTo:@"8.0"] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
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
    
    if ([self.locationRequests count] == 0) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - LYZLocationManager property

- (CLLocation *)currentLocation
{
    if (_currentLocation) {
        if (_currentLocation.coordinate.latitude <= 0.0 && _currentLocation.coordinate.longitude <= 0.0) {
            _currentLocation = nil;
        }
    }
    
    return _currentLocation;
}

#pragma mark - LYZLocationRequestDelegate method

- (void)locationRequestDidTimeout:(LYZLocationRequest *)locationRequest
{
    BOOL isRequestStillPending = NO;
    
    for (LYZLocationRequest *pendingLocationRequest in self.locationRequests) {
        if (pendingLocationRequest.requestID == locationRequest.requestID) {
            isRequestStillPending = YES;
            break;
        }
    }
    
    if (isRequestStillPending) {
        [self completeLocationRequest:locationRequest];
    }
}

#pragma mark - CLLocationManagerDelegate method

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.updateFailed = NO;
    
    CLLocation *recentLocation = [locations lastObject];
    self.currentLocation = recentLocation;
    
    [self processLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.updateFailed = YES;
    
    LYZWARNING(@"The location manager was unable to retrieve a location.");
    
    [self completeAllLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [self completeAllLocationRequests];
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        for (LYZLocationRequest *locationRequest in self.locationRequests) {
            [locationRequest startTimeoutTimerIfNeeded];
        }
    }
#else
    else if (status == kCLAuthorizationStatusAuthorized) {
        for (LYZLocationRequest *locationRequest in self.locationRequests) {
            [locationRequest startTimeoutTimerIfNeeded];
        }
    }
#endif
    
}

#pragma mark -

- (void)processLocationRequests
{
    CLLocation *recentLocation = self.currentLocation;
    
    NSMutableArray *completeLocationRequests = [NSMutableArray array];
    
    for (LYZLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.isTimeout) {
            [completeLocationRequests addObject:locationRequest];
            continue;
        }
        
        if (recentLocation) {
            if (locationRequest.isSubscription) {
                [self processSubscriptionRequest:locationRequest];
                continue;
            }
            else {
                NSTimeInterval timeSinceUpdate = fabs([recentLocation.timestamp timeIntervalSinceNow]);
                CLLocationAccuracy currentLocationHorizontalAccuracy = recentLocation.horizontalAccuracy;
                NSTimeInterval staleThreshold = [locationRequest updateTimeStaleThreshold];
                CLLocationAccuracy horizontalAccuracyThreshold = [locationRequest updateHorizontalAccuracy];
                
                if (timeSinceUpdate <= staleThreshold &&
                    currentLocationHorizontalAccuracy <= horizontalAccuracyThreshold) {
                    [completeLocationRequests addObject:locationRequest];
                    continue;
                }
            }
        }
    }
    
    for (LYZLocationRequest *completeLocationRequest in completeLocationRequests) {
        [self completeLocationRequest:completeLocationRequest];
    }
}

- (void)processSubscriptionRequest:(LYZLocationRequest *)locationRequest
{
    LYZLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    LYZLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:currentLocation];
    
    if (locationRequest.block) {
        locationRequest.block(currentLocation, achievedAccuracy, status);
    }
}

- (LYZLocationStatus)statusForLocationRequest:(LYZLocationRequest *)locationRequest
{
    LYZLocationServiceState serviceState = [LYZLocationManager locationServiceState];
    
    if (serviceState == LYZLocationServiceStateDisabled) {
        return LYZLocationStatusServicesDisabled;
    }
    else if (serviceState == LYZLocationServiceStateNotDetermined) {
        return LYZLocationStatusServicesNotDetermined;
    }
    else if (serviceState == LYZLocationServiceStateDenied) {
        return LYZLocationStatusServicesDenied;
    }
    else if (serviceState == LYZLocationServiceStateRestricted) {
        return LYZLocationStatusServicesRestricted;
    }
    else if (self.updateFailed) {
        return LYZLocationStatusError;
    }
    else if (locationRequest.isTimeout) {
        return LYZLocationStatusTimeout;
    }
    
    return LYZLocationStatusSuccess;
}

- (LYZLocationAccuracy)achievedAccuracyForLocation:(CLLocation *)location
{
    if (! location) {
        return LYZLocationAccuracyNone;
    }
    
    NSTimeInterval timeSinceUpdate = fabs([location.timestamp timeIntervalSinceNow]);
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    
    if (horizontalAccuracy <= kLYZHorizontalAccuracyRoom &&
        timeSinceUpdate <= kLYZUpdateTimeStaleRoom) {
        return LYZLocationAccuracyRoom;
    }
    else if (horizontalAccuracy <= kLYZHorizontalAccuracyHouse &&
             timeSinceUpdate <= kLYZUpdateTimeStaleHouse) {
        return LYZLocationAccuracyHouse;
    }
    else if (horizontalAccuracy <= kLYZHorizontalAccuracyBlock &&
             timeSinceUpdate <= kLYZUpdateTimeStaleBlock) {
        return LYZLocationAccuracyCity;
    }
    else if (horizontalAccuracy <= kLYZHorizontalAccuracyNeighborhood &&
             timeSinceUpdate <= kLYZUpdateTimeStaleNeighborhood) {
        return LYZLocationAccuracyNeighborhood;
    }
    else if (horizontalAccuracy <= kLYZHorizontalAccuracyCity &&
             timeSinceUpdate <= kLYZUpdateTimeStaleCity) {
        return LYZLocationAccuracyCity;
    }
    else {
        return LYZLocationAccuracyNone;
    }
}

- (void)completeAllLocationRequests
{
    NSArray *locationRequests = [self.locationRequests copy];
    for (LYZLocationRequest *locationRequest in locationRequests) {
        [self completeLocationRequest:locationRequest];
    }
}

- (void)completeLocationRequest:(LYZLocationRequest *)locationRequest
{
    if (! locationRequest) {
        return;
    }
    
    [locationRequest complete];
    [self.locationRequests removeObject:locationRequest];
    [self stopUpdatingLocationIfPossible];
    
    LYZLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    LYZLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:currentLocation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (locationRequest.block) {
            locationRequest.block(currentLocation, achievedAccuracy, status);
        }
    });
}

- (void)stopUpdatingLocationIfPossible
{
    if ([self.locationRequests count] == 0) {
        [self.locationManager stopUpdatingLocation];
    }
}

@end
