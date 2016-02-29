//
//  LYZDebugMacro.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#ifndef AppProject_LYZDebugMacro_h
#define AppProject_LYZDebugMacro_h

#define LYZLOGLEVEL_INFO     5
#define LYZLOGLEVEL_WARNING  3
#define LYZLOGLEVEL_ERROR    1

#define LYZMAXLOGLEVEL LYZLOGLEVEL_INFO

#ifdef DEBUG
#define LYZPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define LYZPRINT(xx, ...)  ((void)0)
#endif

#define LYZPRINTMethod() LYZPRINT(@"%s", __PRETTY_FUNCTION__)

#ifdef DEBUG
#define LYZCondition(condition, xx, ...) { if ((condition)) { LYZPRINT(xx, ##__VA_ARGS__); } } ((void)0)
#else
#define LYZCondition(condition, xx, ...) ((void)0)
#endif

#define LYZERROR(xx, ...)  LYZCondition((LYZLOGLEVEL_ERROR <= LYZMAXLOGLEVEL), xx, ##__VA_ARGS__)
#define LYZWARNING(xx, ...)  LYZCondition((LYZLOGLEVEL_WARNING <= LYZMAXLOGLEVEL), xx, ##__VA_ARGS__)
#define LYZINFO(xx, ...)  LYZCondition((LYZLOGLEVEL_INFO <= LYZMAXLOGLEVEL), xx, ##__VA_ARGS__)

#ifdef DEBUG
#define LYZAssert(condition) NSAssert(condition, ([NSString stringWithFormat:@"%s(%d):", __PRETTY_FUNCTION__, __LINE__]));
#else
#define LYZAssert(condition) do {} while (0)
#endif

#endif
