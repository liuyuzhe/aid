//
//  LYZLocationRequest.h
//  AppProject
//
//  Created by 刘育哲 on 15/3/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZLocationDefine.h"

@class LYZLocationRequest;

@protocol LYZLocationRequestDelegate <NSObject>

@required
- (void)locationRequestDidTimeout:(LYZLocationRequest *)locationRequest;

@end



@interface LYZLocationRequest : NSObject

@property (nonatomic, weak) id<LYZLocationRequestDelegate> delegate;
@property (nonatomic, assign) LYZLocationAccuracy desiredAccuracy;
@property (nonatomic, copy) LYZLocationRequestBlock block;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign, readonly) BOOL isTimeout;

@property (nonatomic, assign, readonly) LYZLocationRequestID requestID;
@property (nonatomic, assign, readonly) BOOL isSubscription;

- (void)complete;
- (void)cancel;

- (void)startTimeoutTimerIfNeeded;

- (NSTimeInterval)updateTimeStaleThreshold;
- (CLLocationAccuracy)updateHorizontalAccuracy;

@end
