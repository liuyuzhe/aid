//
//  LYZKeyChain.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/7.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZKeyChain.h"
#import "LYZDebugMacro.h"

static NSString * const LYZKeyChainDefaultDomain = @"LYZKeyChain";

@implementation LYZKeyChain

IS_SINGLETON(LYZKeyChain)

#pragma mark - LYZKeyChain method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultDomain = LYZKeyChainDefaultDomain;
    }
    return self;
}

#pragma mark - LYZKeyChain public

- (BOOL)hasObjectForKey:(NSString *)key withDomain:(NSString *)domain;
{
    return [self objectForKey:key withDomain:domain] ? YES : NO;
}

- (id)objectForKey:(NSString *)key withDomain:(NSString *)domain;
{
    if (! key) {
        return nil;
    }
    if (! domain) {
        domain = self.defaultDomain;
    }
    
    id retValue;
    
    NSMutableDictionary *keychainQuery = [[self class] getKeychainForKey:key andDomain:domain];
    
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (status == noErr) {
        retValue = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
    }
    
    return retValue;
}

- (void)setObject:(id)object forKey:(NSString *)key withDomain:(NSString *)domain
{
    if(! domain) {
        domain = self.defaultDomain;
    }
    
    NSMutableDictionary *keychainQuery = [[self class] getKeychainForKey:key andDomain:domain];
    
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:(__bridge_transfer id)kSecValueData];
    
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

- (void)removeObjectForKey:(NSString *)key withDomain:(NSString *)domain
{
    if (! domain) {
        domain = self.defaultDomain;
    }
    
    NSMutableDictionary *keychainQuery = [[self class] getKeychainForKey:key andDomain:domain];
    
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}


#pragma mark - LYZKeyChain helper

+ (NSMutableDictionary *)getKeychainForKey:(NSString *)key andDomain:(NSString *)domain
{
    NSMutableDictionary * mutableDic = [@{
      (__bridge_transfer id)kSecClass :          (__bridge_transfer id)kSecClassGenericPassword,
      (__bridge_transfer id)kSecAttrService :    domain,
      (__bridge_transfer id)kSecAttrAccount :    key,
      (__bridge_transfer id)kSecAttrAccessible : (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock
    } mutableCopy];
    
    return mutableDic;
}

#pragma mark - LYZCacheProtocol method

- (BOOL)hasObjectForKey:(NSString *)key
{
    return [self hasObjectForKey:key withDomain:nil];
}

- (id)objectForKey:(NSString *)key
{
    return [self objectForKey:key withDomain:nil];
}

- (void)setObject:(id)object forKey:(NSString *)key;
{
    [self setObject:object forKey:key withDomain:nil];
}

- (void)removeObjectForKey:(NSString *)key
{
    [self removeObjectForKey:key withDomain:nil];
}

@end
