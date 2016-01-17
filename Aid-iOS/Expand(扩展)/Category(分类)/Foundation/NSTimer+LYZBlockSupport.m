//
//  NSTimer+LYZBlockSupport.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSTimer+LYZBlockSupport.h"
#import "NSObject+LYZRuntimeMethod.h"

@interface NSTimer ()

@property (nonatomic, strong) NSDate *pauseDate;
@property (nonatomic, strong) NSDate *previousFireDate;

@end


@implementation NSTimer (LYZBlockSupport)

#pragma mark - LYZBlockSupport public

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(dispatch_block_t)block
                                    repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(onTimerFired:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                             block:(dispatch_block_t)block
                           repeats:(BOOL)repeats
{
    return [self timerWithTimeInterval:interval
                                target:self
                              selector:@selector(onTimerFired:)
                              userInfo:[block copy]
                               repeats:repeats];
}

- (void)pauseTimer
{
    self.pauseDate = [NSDate date];
    self.previousFireDate = self.fireDate;
    self.fireDate = [NSDate distantFuture];
}

- (void)resumeTimer
{
    const NSTimeInterval pauseTime = fabs([self.pauseDate timeIntervalSinceNow]);
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate];
}

#pragma mark - LYZBlockSupport helper

+ (void)onTimerFired:(NSTimer *)timer;
{
    dispatch_block_t block = timer.userInfo;
    if (block) {
        block();
    }
}

#pragma mark - getters and setters

- (NSDate *)pauseDate
{
    return [self getAssociatedValueForKey:@selector(pauseDate)];
}

- (void)setPauseDate:(NSDate *)pauseDate
{
    [self setAssociateValue:pauseDate withKey:@selector(pauseDate)];
}

- (NSDate *)previousFireDate
{
    return [self getAssociatedValueForKey:@selector(previousFireDate)];
}

- (void)setPreviousFireDate:(NSDate *)previousFireDate
{
    [self setAssociateValue:previousFireDate withKey:@selector(previousFireDate)];
}

@end
