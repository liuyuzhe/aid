//
//  LYZMathMacro.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#ifndef AppProject_LYZMathMacro_h
#define AppProject_LYZMathMacro_h

#define LYZDegreesToRadian(x) (M_PI * (x) / 180.0) // 角度转弧度
#define LYZRadianToDegrees(r) (r * 180.0) / (M_PI) // 弧度转角度

#define LYZKBInBytes (1024)
#define LYZMBInBytes (LYZKBInBytes * 1024)
#define LYZGBInBytes (LYZMBInBytes * 1024)
#define LYZTBInBytes (LYZGBInBytes * 1024)

#define LYZMinuteInSeconds (60)
#define LYZHourInSeconds (3600) // 60 * 60
#define LYZDayInSeconds (86400) // 60 * 60 * 24
#define LYZWeekInSeconds (604800) // 60 * 60 * 24 * 7

#endif
