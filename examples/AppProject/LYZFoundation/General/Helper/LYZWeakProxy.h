//
//  LYZWeakProxy.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 sample code:
 
 M80WeakProxy *weakProxy = [M80WeakProxy weakProxyForObject:self];
 self.displayLink = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(displayDidRefresh:)];
 
 */
@interface LYZWeakProxy : NSObject

+ (instancetype)weakProxyForObject:(id)object;

@end
