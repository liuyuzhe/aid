//
//  LYZUserDefault.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/7.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZUserDefault.h"
#import "LYZApplicationInfo.h"

@implementation LYZUserDefault

IS_SINGLETON(LYZUserDefault)

#pragma mark - LYZCacheProtocol method

- (BOOL)hasObjectForKey:(NSString *)key
{
    if (! key) {
        return NO;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(NSString *)key
{
    if (! key) {
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    if (! object || ! key) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
    if (! key) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAllObjects
{
    NSString *appDomain = [LYZApplicationInfo appIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [NSUserDefaults resetStandardUserDefaults]; //清空缓存并重置
}

@end
