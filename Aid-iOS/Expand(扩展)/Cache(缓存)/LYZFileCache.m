//
//  LYZFileCache.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZFileCache.h"
#import "LYZFileManager.h"
#import "LYZApplicationInfo.h"

@implementation LYZFileCache

IS_SINGLETON(LYZFileCache)

#pragma mark - LYZFileCache method

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _cachePath = [LYZFileManager pathForCachesDirectoryWithPath:path];
    }
    return self;
}

- (instancetype)init
{
    NSString *defaultPath = [LYZApplicationInfo appVersion];
    return [self initWithPath:defaultPath];
}

#pragma mark - LYZFileCache helper

- (NSString *)fullPathForKey:(NSString *)key
{
    return [self.cachePath stringByAppendingPathComponent:key];
}

#pragma mark - LYZFileCache property

- (CGFloat)costSize
{
    return [LYZFileManager MByteOfDirectoryAtPath:self.cachePath];
}

#pragma mark - LYZCacheProtocol method

- (BOOL)hasObjectForKey:(NSString *)key
{
    if (! key) {
        return NO;
    }
    
    return [LYZFileManager isExistAtPath:[self fullPathForKey:key]];
}

- (NSData *)objectForKey:(NSString *)key
{
    if (! key) {
        return nil;
    }
    
    return [LYZFileManager readFileAtPathAsData:[self fullPathForKey:key]];
}

- (void)setObject:(NSData *)object forKey:(NSString *)key
{
    if (! object || ! key) {
        return;
    }
    
    [LYZFileManager createDirectoryAtPath:self.cachePath];
    [LYZFileManager writeFileAtPath:[self fullPathForKey:key] useData:object];
}

- (void)removeObjectForKey:(NSString *)key
{
    if (! key) {
        return;
    }
    
    [LYZFileManager removeItemAtPath:[self fullPathForKey:key]];
}

- (void)removeAllObjects
{
    [LYZFileManager removeItemAtPath:[self cachePath]];
}

@end
