//
//  LYZCacheProtocol.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYZCacheProtocol <NSObject>

@required
- (BOOL)hasObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@optional
- (void)removeAllObjects;

@end
