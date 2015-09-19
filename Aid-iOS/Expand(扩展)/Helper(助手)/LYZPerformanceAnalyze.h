//
//  LYZPerformanceAnalyze.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYZPerformanceAnalyze : NSObject

+ (CGFloat)timeCost:(dispatch_block_t)block;

@end
