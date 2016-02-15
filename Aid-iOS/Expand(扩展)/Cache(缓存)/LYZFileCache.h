//
//  LYZFileCache.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LYZCacheProtocol.h"
#import "LYZSingletonMacro.h"

@interface LYZFileCache : NSObject <LYZCacheProtocol>

AS_SINGLETON(LYZFileCache)

@property (nonatomic, copy, readonly) NSString *cachePath; /**< @return [LYZApplicationInfo appVersion] */
@property (nonatomic, assign, readonly, getter=costSize) CGFloat costSize; /**< @return MB */

- (instancetype)initWithPath:(NSString *)path;

- (BOOL)hasObjectForKey:(NSString *)key;
- (NSData *)objectForKey:(NSString *)key;
- (void)setObject:(NSData *)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

@end
