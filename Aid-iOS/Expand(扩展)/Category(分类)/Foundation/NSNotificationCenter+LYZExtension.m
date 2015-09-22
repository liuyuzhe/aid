//
//  NSNotificationCenter+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/8/3.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSNotificationCenter+LYZExtension.h"

@implementation NSNotificationCenter (LYZExtension)

- (void)postNotificationOnMainThread:(NSNotification *)notification
{
    if ([NSThread isMainThread]) {
        [self postNotification:notification];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotification:notification];
        });
    }
}
- (void)postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject
{
    if ([NSThread isMainThread]) {
        [self postNotificationName:aName object:anObject];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotificationName:aName object:anObject];
        });
    }
}

- (void)postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    if ([NSThread isMainThread]) {
        [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotificationName:aName object:anObject userInfo:aUserInfo];
        });
    }
}

@end
