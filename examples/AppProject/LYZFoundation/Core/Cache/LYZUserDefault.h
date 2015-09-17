//
//  LYZUserDefault.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/7.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYZCacheProtocol.h"
#import "LYZSingletonMacro.h"

@interface LYZUserDefault : NSObject <LYZCacheProtocol>

AS_SINGLETON(LYZUserDefault)


- (BOOL)hasObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

@end
