//
//  LYZWeatherDataModel.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/27.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYZWealResultModel;
@class LYZWealReturnDataModel;
@class LYZWealRealtimeModel;
@class LYZWeatherBasicModel;

@interface LYZWeatherDataModel : NSObject

@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) LYZWealResultModel *result;
@property (nonatomic, strong) NSString *error_code;

@end


@interface LYZWealResultModel : NSObject

@property (nonatomic, strong) LYZWealReturnDataModel *data;

@end


@interface LYZWealReturnDataModel : NSObject

@property (nonatomic, strong) LYZWealRealtimeModel *realtime;

@end


@interface LYZWealRealtimeModel : NSObject

@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) LYZWeatherBasicModel *weather;

@end


@interface LYZWeatherBasicModel : NSObject

@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *img;

@end