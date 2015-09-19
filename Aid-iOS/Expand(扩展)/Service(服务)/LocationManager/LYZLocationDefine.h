//
//  LYZLocationDefine.h
//  AppProject
//
//  Created by 刘育哲 on 15/3/25.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#ifndef AppProject_LYZLocationDefine_h
#define AppProject_LYZLocationDefine_h

@import CoreLocation;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// in meters
static const CGFloat kLYZHorizontalAccuracyCity =         3000.0;
static const CGFloat kLYZHorizontalAccuracyNeighborhood = 1000.0;
static const CGFloat kLYZHorizontalAccuracyBlock =         100.0;
static const CGFloat kLYZHorizontalAccuracyHouse =          15.0;
static const CGFloat kLYZHorizontalAccuracyRoom =           5.0;

// in seconds
static const CGFloat kLYZUpdateTimeStaleCity =             600.0;
static const CGFloat kLYZUpdateTimeStaleNeighborhood =     300.0;
static const CGFloat kLYZUpdateTimeStaleBlock =             60.0;
static const CGFloat kLYZUpdateTimeStaleHouse =             15.0;
static const CGFloat kLYZUpdateTimeStaleRoom =               5.0;

typedef NSInteger LYZLocationRequestID;

typedef NS_ENUM(NSInteger, LYZLocationServiceState)
{
    LYZLocationServiceStateAvailable = 0,
    LYZLocationServiceStateNotDetermined = 1,
    LYZLocationServiceStateRestricted = 2,
    LYZLocationServiceStateDenied = 3,
    LYZLocationServiceStateDisabled = 4,
};

typedef NS_ENUM(NSInteger, LYZLocationAccuracy)
{
    LYZLocationAccuracyNone = 0,
    LYZLocationAccuracyCity = 1,
    LYZLocationAccuracyNeighborhood = 2,
    LYZLocationAccuracyBlock = 3,
    LYZLocationAccuracyHouse = 4,
    LYZLocationAccuracyRoom = 5,
};

typedef NS_ENUM(NSInteger, LYZLocationStatus)
{
    LYZLocationStatusSuccess = 0,
    LYZLocationStatusServicesNotDetermined = 1,
    LYZLocationStatusServicesDenied = 2,
    LYZLocationStatusServicesRestricted = 3,
    LYZLocationStatusServicesDisabled = 4,
    LYZLocationStatusError = 5,
    LYZLocationStatusTimeout = 6,
};

typedef void(^LYZLocationRequestBlock) (CLLocation *currentLocation, LYZLocationAccuracy accuary, LYZLocationStatus state);

#endif 