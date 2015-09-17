//
//  LYZMemoryCache.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYZCacheProtocol.h"
#import "LYZSingletonMacro.h"

@interface LYZMemoryCache : NSObject <LYZCacheProtocol>

AS_SINGLETON(LYZMemoryCache)

@property (nonatomic, assign, readonly) NSUInteger maxCount;
@property (nonatomic, assign, readonly) NSUInteger maxCostSize; /**< @return MB */

- (void)setObject:(NSData *)object forKey:(NSString *)key withCost:(NSUInteger)costSize;


- (BOOL)hasObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

@end
