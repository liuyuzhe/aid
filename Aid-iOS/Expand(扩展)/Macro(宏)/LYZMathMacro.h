//
//  LYZMathMacro.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#ifndef AppProject_LYZMathMacro_h
#define AppProject_LYZMathMacro_h

#import <Foundation/Foundation.h>

#define LYZDegreesToRadian(x) (M_PI * (x) / 180.0) // 角度转弧度
#define LYZRadianToDegrees(r) (r * 180.0) / (M_PI) // 弧度转角度

static const NSUInteger LYZSecondsInMinute = 60;
static const NSUInteger LYZSecondsInHour = 60 * 60;
static const NSUInteger LYZSecondsInDay = LYZSecondsInHour * 24;
static const NSUInteger LYZMillisecondsInDay = LYZSecondsInDay * 1000;
static const NSUInteger LYZSecondsInWeek = LYZSecondsInDay * 7;
static const NSUInteger LYZSecondsInMonth_28 = LYZSecondsInDay * 28;
static const NSUInteger LYZSecondsInMonth_29 = LYZSecondsInDay * 29;
static const NSUInteger LYZSecondsInMonth_30 = LYZSecondsInDay * 30;
static const NSUInteger LYZSecondsInMonth_31 = LYZSecondsInDay * 31;

static const NSUInteger LYZBytesInKB = 1024;
static const NSUInteger LYZBytesInMB = LYZBytesInKB * 1024;
static const NSUInteger LYZBytesInGB = LYZBytesInMB * 1024;

#endif
