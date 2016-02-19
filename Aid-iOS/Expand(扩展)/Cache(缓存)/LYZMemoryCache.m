//
//  LYZMemoryCache.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZMemoryCache.h"
#import "LYZMathMacro.h"

static const NSUInteger LYZMemoryCacheDefultMaxCount = 100;
static const NSUInteger LYZMemoryCacheDefultMaxCostSize = 10 * LYZBytesInMB;

@interface LYZMemoryCache ()

@property (nonatomic, strong) NSCache *memoryCache;

@end


@implementation LYZMemoryCache

IS_SINGLETON(LYZMemoryCache)

#pragma mark - LYZMemoryCache method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memoryCache = [[NSCache alloc] init];
        
        _memoryCache.countLimit = LYZMemoryCacheDefultMaxCount;
        _maxCount = _memoryCache.countLimit;
        
        _memoryCache.totalCostLimit = LYZMemoryCacheDefultMaxCostSize;
        _maxCostSize = _memoryCache.totalCostLimit / LYZBytesInMB;
    }
    return self;
}

#pragma mark - LYZMemoryCache public

- (void)setObject:(NSData *)object forKey:(NSString *)key withCost:(NSUInteger)costSize
{
    if (! object|| ! key) {
        return;
    }
    
    [self.memoryCache setObject:object forKey:key cost:costSize];
}

#pragma mark - LYZCacheProtocol method

- (BOOL)hasObjectForKey:(NSString *)key
{
    if (! key) {
        return NO;
    }
    
    return [self objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(NSString *)key
{
    if (! key) {
        return nil;
    }
    
    return [self.memoryCache objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    if (! object || ! key) {
        return;
    }
    
    [self.memoryCache setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    if (! key) {
        return;
    }
    
    [self.memoryCache removeObjectForKey:key];
}

- (void)removeAllObjects
{
    [self.memoryCache removeAllObjects];
}

@end
