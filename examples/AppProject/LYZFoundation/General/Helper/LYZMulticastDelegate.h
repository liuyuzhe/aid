//
//  LYZMulticastDelegate.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/24.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYZMulticastDelegate : NSObject

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

- (NSUInteger)count;
- (NSUInteger)countForSelector:(SEL)aSelector;
- (BOOL)hasDelegateThatRespondsToSelector:(SEL)aSelector;

@end
