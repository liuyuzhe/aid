//
//  LYZNetworkManager.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/27.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZNetworkManager.h"
#import "AidNetwork.h"

static NSString *const kWeatherDataApi = @"http://op.juhe.cn/onebox/weather/query";
static NSString *const kApiKey = @"dd156fb77845d1442789507cac58cabd";

@implementation LYZNetworkManager

IS_SINGLETON(LYZNetworkManager)

- (void)getWeatherDataByCityName:(NSString *)cityName success:(LYZGetCityWeatherSuccess)success
{
    NSDictionary *params = @{@"cityname": cityName,
                             @"key": kApiKey,
                             @"dtype": @""};
    
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:kWeatherDataApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LYZWeatherDataModel *weatherModel = [LYZWeatherDataModel yy_modelWithJSON:responseObject];
        if (success) {
            success(weatherModel);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//
//    [AidNetwork getWithUrl:kWeatherDataApi params:params success:^(id response) {
//        LYZWeatherDataModel *weatherModel = [LYZWeatherDataModel yy_modelWithDictionary:response];
//        if (success) {
//            success(weatherModel);
//        }
//        
//        LYZINFO(@"获取天气成功");
//    } failure:^(NSError *error) {
//        LYZERROR(@"获取天气失败");
//    }];
}

- (void)getWeatherDataByCityNames:(NSArray<NSString *> *)cityNames success:(LYZGetCitysWeatherSuccess)success
{
    NSMutableArray<LYZWeatherDataModel *> *weatherModels = [NSMutableArray array];

    dispatch_group_t getDataGroup = dispatch_group_create();
    
    for (NSString *cityName in cityNames) {
        NSDictionary *params = @{@"city": cityName,
                                 @"key": kApiKey};
    
        dispatch_group_enter(getDataGroup);

        [AidNetwork getWithUrl:kWeatherDataApi params:params success:^(id response) {
            LYZWeatherDataModel *weatherModel = [LYZWeatherDataModel yy_modelWithDictionary:response];
            [weatherModels addObject:weatherModel];
            
            dispatch_group_leave(getDataGroup);

            LYZINFO(@"获取天气成功");
        } failure:^(NSError *error) {
            
            dispatch_group_leave(getDataGroup);

            LYZERROR(@"获取天气失败");
        }];
    }
    
    dispatch_group_notify(getDataGroup, dispatch_get_main_queue(), ^{
        if (success) {
            success([weatherModels copy]);
        }
    });
}

@end
