//
//  LYZLocationRequest.m
//  AppProject
//
//  Created by 刘育哲 on 15/3/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZLocationRequest.h"
#import "LYZTimerHolder.h"

static LYZLocationRequestID _nextRequestID = 0;

@interface LYZLocationRequest () <LYZTimerHolderDelegate>

@property (nonatomic, strong) LYZTimerHolder *timeoutTimer;
@property (nonatomic, strong) NSDate *requestStartTime;
@property (nonatomic, assign, readwrite) BOOL isTimeout;

@end


@implementation LYZLocationRequest

#pragma mark - LYZLocationRequest method

- (instancetype)init
{
    return [self initWithRequestID:[[self class] getUniqueRequestID]];
}

- (instancetype)initWithRequestID:(LYZLocationRequestID)requestID
{
    self = [super init];
    if (self) {
        _isTimeout = NO;
        _requestID = requestID;
    }
    return self;
}

- (void)dealloc
{
    [_timeoutTimer stopTimer];
}

#pragma mark - LYZLocationRequest public

- (void)complete
{
    [self.timeoutTimer stopTimer];
    self.timeoutTimer = nil;
}

- (void)cancel
{
    [self.timeoutTimer stopTimer];
    self.timeoutTimer = nil;
}

- (void)startTimeoutTimerIfNeeded
{
    if (self.timeout > 0 && ! self.timeoutTimer) {
        self.timeoutTimer = [[LYZTimerHolder alloc] init];
        [self.timeoutTimer startTimer:self.timeout delegate:self repeats:NO];
        self.isTimeout = self.timeoutTimer.isTimeout;
    }
}

- (NSTimeInterval)updateTimeStaleThreshold
{
    switch (self.desiredAccuracy) {
        case LYZLocationAccuracyNone:
            return 0.0;
            break;
        case LYZLocationAccuracyCity:
            return kLYZUpdateTimeStaleCity;
            break;
        case LYZLocationAccuracyNeighborhood:
            return kLYZUpdateTimeStaleNeighborhood;
            break;
        case LYZLocationAccuracyBlock:
            return kLYZUpdateTimeStaleBlock;
            break;
        case LYZLocationAccuracyHouse:
            return kLYZUpdateTimeStaleHouse;
            break;
        case LYZLocationAccuracyRoom:
            return kLYZUpdateTimeStaleRoom;
            break;
    }
}

- (CLLocationAccuracy)updateHorizontalAccuracy
{
    switch (self.desiredAccuracy) {
        case LYZLocationAccuracyNone:
            return 0.0;
            break;
        case LYZLocationAccuracyCity:
            return kLYZHorizontalAccuracyCity;
            break;
        case LYZLocationAccuracyNeighborhood:
            return kLYZHorizontalAccuracyNeighborhood;
            break;
        case LYZLocationAccuracyBlock:
            return kLYZHorizontalAccuracyBlock;
            break;
        case LYZLocationAccuracyHouse:
            return kLYZHorizontalAccuracyHouse;
            break;
        case LYZLocationAccuracyRoom:
            return kLYZHorizontalAccuracyRoom;
            break;
    }
}

#pragma mark - LYZLocationRequest helper

+ (LYZLocationRequestID)getUniqueRequestID
{
    ++ _nextRequestID;
    return _nextRequestID;
}

#pragma mark - LYZTimerHolderDelegate method

- (void)timerDidFire:(LYZTimerHolder *)timeHolder
{
    if ([self.delegate respondsToSelector:@selector(locationRequestDidTimeout:)]) {
        [self.delegate locationRequestDidTimeout:self];
    }
}

#pragma mark - NSObject method

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    if (((LYZLocationRequest *)object).requestID == self.requestID) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[NSString stringWithFormat:@"%ld", (long) self.requestID] hash];
}

@end
