//
//  LYZKeyChain.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/7.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYZCacheProtocol.h"
#import "LYZSingletonMacro.h"

@interface LYZKeyChain : NSObject <LYZCacheProtocol>

@property (nonatomic, copy, readonly) NSString *defaultDomain; /**< @return @"LYZKeyChain" */

AS_SINGLETON(LYZKeyChain)

- (instancetype)initWithDomain:(NSString *)domain;

- (BOOL)hasObjectForKey:(NSString *)key withDomain:(NSString *)domain;
- (id)objectForKey:(NSString *)key withDomain:(NSString *)domain;
- (void)setObject:(id)object forKey:(NSString *)key withDomain:(NSString *)domain;
- (void)removeObjectForKey:(NSString *)key withDomain:(NSString *)domain;


- (BOOL)hasObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end
