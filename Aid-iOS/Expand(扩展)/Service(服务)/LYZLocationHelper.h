//
//  LYZLocationHelper.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/29.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYZLocationHelper;

@protocol LYZLocationHelperDelegate <NSObject>

@optional
- (void)locationHelper:(LYZLocationHelper *)location didSuccess:(NSArray<CLPlacemark *> *)placemarks;
- (void)locationHelper:(LYZLocationHelper *)location didFailed:(NSError *)error;
- (void)locationHelperDidClose:(LYZLocationHelper *)location;

@end


@interface LYZLocationHelper : NSObject

@property (nonatomic, weak) id<LYZLocationHelperDelegate> delegate;

AS_SINGLETON(LYZLocationHelper)

- (void)startLocation;

@end
