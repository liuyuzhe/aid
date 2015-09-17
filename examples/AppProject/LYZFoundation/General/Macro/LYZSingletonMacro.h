//
//  LYZSingletonMacro.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/18.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#ifndef AppProject_LYZSingletonMacro_h
#define AppProject_LYZSingletonMacro_h

#define AS_SINGLETON( ... ) \
+ (instancetype)sharedInstance;

#define IS_SINGLETON( ... ) \
+ (instancetype)sharedInstance \
{ \
static id _sharedObject; \
static dispatch_once_t once; \
dispatch_once( &once, ^{ _sharedObject = [[self alloc] init]; } ); \
return _sharedObject; \
}

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static id _sharedObject; \
static dispatch_once_t once; \
dispatch_once( &once, ^{ _sharedObject = block(); } ); \
return _sharedObject;

#endif
