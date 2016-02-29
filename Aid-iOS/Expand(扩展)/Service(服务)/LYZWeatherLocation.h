//
//  LYZWeatherLocation.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/27.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYZWeatherLocation;

@protocol LYZWeatherLocationDelegate <NSObject>

@optional
- (void)weatherLocation:(LYZWeatherLocation *)location didSuccess:(NSString *)cityName;
- (void)weatherLocation:(LYZWeatherLocation *)location didFailed:(NSError *)error;
- (void)weatherLocationDidClose:(LYZWeatherLocation *)location;

@end

@interface LYZWeatherLocation : NSObject

@property (nonatomic, weak) id<LYZWeatherLocationDelegate> delegate;

AS_SINGLETON(LYZLocationManager)

- (void)startLocation;

@end
