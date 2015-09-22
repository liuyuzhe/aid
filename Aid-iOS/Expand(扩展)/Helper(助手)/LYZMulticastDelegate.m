//
//  LYZMulticastDelegate.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/24.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZMulticastDelegate.h"
#import "LYZDebugMacro.h"

@interface LYZDelegateNode : NSObject

@property (nonatomic, weak) id nodeDelegate;

+ (LYZDelegateNode *)nodeForDelegate:(id)delegate;

@end


@implementation LYZDelegateNode

+ (LYZDelegateNode *)nodeForDelegate:(id)delegate
{
    LYZDelegateNode *instance = [[LYZDelegateNode alloc] init];
    instance.nodeDelegate = delegate;
    
    return instance;
}

@end




@interface LYZMulticastDelegate ()

@property (nonatomic, strong) NSMutableArray *delegateNodes;

@end


@implementation LYZMulticastDelegate

#pragma mark - LYZMulticastDelegate method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegateNodes = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - LYZMulticastDelegate public

- (void)addDelegate:(id)delegate
{
    [self removeDelegate:delegate];
    
    LYZDelegateNode *node = [LYZDelegateNode nodeForDelegate:delegate];
    [_delegateNodes addObject:node];
}

- (void)removeDelegate:(id)delegate
{
    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
    for (NSUInteger i = 0; i < [_delegateNodes count]; ++ i) {
        LYZDelegateNode *node = [_delegateNodes objectAtIndex:i];
        if (node.nodeDelegate == delegate) {
            [indexs addIndex:i];
        }
    }
    
    if ([indexs count] > 0) {
        [_delegateNodes removeObjectsAtIndexes:indexs];
    }
}

- (void)removeAllDelegates
{
    [_delegateNodes removeAllObjects];
}

- (NSUInteger)count
{
    return [_delegateNodes count];
}

- (NSUInteger)countForSelector:(SEL)aSelector
{
    NSUInteger count = 0;
    for (LYZDelegateNode *node in _delegateNodes) {
        if ([node.nodeDelegate respondsToSelector:aSelector]) {
            ++ count;
        }
    }
    return count;
}

- (BOOL)hasDelegateThatRespondsToSelector:(SEL)aSelector
{
    BOOL hasSelector = NO;
    for (LYZDelegateNode *node in _delegateNodes) {
        if ([node.nodeDelegate respondsToSelector:aSelector]) {
            hasSelector = YES;
            break;
        }
    }
    return hasSelector;
}

#pragma mark - NSObject method

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    for (LYZDelegateNode *node in _delegateNodes) {
        NSMethodSignature *method = [node.nodeDelegate methodSignatureForSelector:aSelector];
        if (method) {
            return method;
        }
    }
    
    //如果发现没有可以响应当前方法的Node,就返回一个空方法，否则会引起崩溃
    return [[self class] instanceMethodSignatureForSelector:@selector(doNothing)];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    BOOL hasNilDelegate = NO;
    
    NSMutableArray *nodeDelegates = [NSMutableArray array];
    
    for (LYZDelegateNode *node in _delegateNodes) {
        id nodeDelegate = node.nodeDelegate;

        if (! nodeDelegate) {
            hasNilDelegate = YES;
        }
        else if ([nodeDelegate respondsToSelector:selector]) {
            [nodeDelegates addObject:nodeDelegate];
        }
    }
    
    if (hasNilDelegate)
    {
        [self removeDelegate:nil];
    }
    
    for (id nodeDelegate in nodeDelegates)
    {
        [invocation invokeWithTarget:nodeDelegate];
    }
}

#pragma mark - NSObject helper

- (void)doNothing
{
    LYZERROR(@"This method must not be called!");
}

@end
