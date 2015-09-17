//
//  NSTimer+LYZBlockSupport.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSTimer+LYZBlockSupport.h"

@implementation NSTimer (LYZBlockSupport)

#pragma mark - LYZBlockSupport public

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(LYZTimerBlock)block
                                    repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(onTimerFired:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                             block:(LYZTimerBlock)block
                           repeats:(BOOL)repeats
{
    return [self timerWithTimeInterval:interval
                                target:self
                              selector:@selector(onTimerFired:)
                              userInfo:[block copy]
                               repeats:repeats];
}

#pragma mark - LYZBlockSupport helper

+ (void)onTimerFired:(NSTimer *)timer;
{
    LYZTimerBlock block = timer.userInfo;
    if (block) {
        block();
    }
}

@end
