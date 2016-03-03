//
//  LYZNetworkManager.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/27.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYZSingletonMacro.h"

#import "LYZWeatherDataModel.h"

typedef void (^LYZGetCityWeatherSuccess)(LYZWeatherDataModel *dataModel);
typedef void (^LYZGetCitysWeatherSuccess)(NSArray<LYZWeatherDataModel *> *dataModels);
typedef void (^LYZResponseFailure)(NSError *error);

@interface LYZNetworkManager : NSObject

AS_SINGLETON(LYZNetworkManager)

- (void)getWeatherDataByCityName:(NSString *)cityName success:(LYZGetCityWeatherSuccess)success;
- (void)getWeatherDataByCityNames:(NSArray<NSString *> *)cityNames success:(LYZGetCitysWeatherSuccess)success;

@end
