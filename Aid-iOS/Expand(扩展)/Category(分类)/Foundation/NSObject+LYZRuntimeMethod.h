//
//  NSObject+LYZRuntimeMethod.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/15.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LYZRuntimeMethod)

+ (void)addMethod:(Class)fromClass with:(SEL)sel;
+ (void)replaceMethod:(Class)fromClass with:(SEL)sel;
+ (void)swapInstanceMethod:(SEL)oldSel with:(SEL)newSel;
+ (void)swapClassMethod:(SEL)oldSel with:(SEL)newSel;

#pragma mark -

- (void)setAssociateValue:(id)value withKey:(const void *)key;
- (void)setAssociateWeakValue:(id)value withKey:(const void *)key;
- (void)removeAssociatedValues;
- (id)getAssociatedValueForKey:(const void *)key;

#pragma mark -

/** 该类是否响应某个selector的类方法 @attention 不同于respondsToSelector:这个是对于某个Class而不是Instance的 */
+ (BOOL)classRespondsToSelector:(SEL)aSelector;

+ (NSString *)className;
- (NSString *)className;

@end
