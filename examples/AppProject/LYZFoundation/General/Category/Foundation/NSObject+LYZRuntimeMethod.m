//
//  NSObject+LYZRuntimeMethod.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/15.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+LYZRuntimeMethod.h"

@implementation NSObject (LYZRuntimeMethod)

+ (void)addMethod:(Class)fromClass with:(SEL)sel
{
    Method method = class_getInstanceMethod(fromClass, sel);
    
    class_addMethod(self, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

+ (void)replaceMethod:(Class)fromClass with:(SEL)sel
{
    Method method = class_getInstanceMethod(fromClass, sel);
    
    class_replaceMethod(self, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

+ (void)swapInstanceMethod:(SEL)oldSel with:(SEL)newSel
{
    Method oldMethod = class_getInstanceMethod(self, oldSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)swapClassMethod:(SEL)oldSel with:(SEL)newSel
{
    Class cls = object_getClass(self);
    Method oldMethod = class_getClassMethod(cls, oldSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    
    method_exchangeImplementations(oldMethod, newMethod);
}

#pragma mark -

- (void)setAssociateValue:(id)value withKey:(const void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociateWeakValue:(id)value withKey:(const void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeAssociatedValues
{
    objc_removeAssociatedObjects(self);
}

- (id)getAssociatedValueForKey:(const void *)key
{
    return objc_getAssociatedObject(self, key);
}

#pragma mark -

+ (BOOL)classRespondsToSelector:(SEL)aSelector
{
    if (! aSelector) {
        return NO;
    }
    
    Method method = class_getClassMethod(self, aSelector);
    return (method != nil);
}

+ (NSString *)className
{
    return NSStringFromClass(self);
}

- (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
