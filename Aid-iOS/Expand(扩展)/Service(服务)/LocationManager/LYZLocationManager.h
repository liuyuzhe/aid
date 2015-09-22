//
//  LYZLocationManager.h
//  AppProject
//
//  Created by 刘育哲 on 15/3/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZSingletonMacro.h"
#import "LYZLocationDefine.h"

@interface LYZLocationManager : NSObject

AS_SINGLETON(LYZLocationManager)

+ (LYZLocationServiceState)locationServiceState;

- (LYZLocationRequestID)requestLocationWithDesiredAccuracy:(LYZLocationAccuracy)desiredAccuracy
                                   timeout:(NSTimeInterval)timeout
                                     block:(LYZLocationRequestBlock)block;

- (LYZLocationRequestID)requestLocationWithDesiredAccuracy:(LYZLocationAccuracy)desiredAccuracy
                                                    timeout:(NSTimeInterval)timeout
                                       delayUntilAuthorized:(BOOL)delayUntilAuthorized
                                     block:(LYZLocationRequestBlock)block;

- (LYZLocationRequestID)subscribeToLocationUpdatesWithBlock:(LYZLocationRequestBlock)block;

- (void)cancelLocationRequest:(LYZLocationRequestID)requestID;

@end
