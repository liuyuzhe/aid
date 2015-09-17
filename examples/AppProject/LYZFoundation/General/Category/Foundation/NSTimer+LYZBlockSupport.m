//
//  NSTimer+LYZBlockSupport.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSTimer+LYZBlockSupport.h"
#import "NSObject+LYZRuntimeMethod.h"

static NSString * const NSTimerLYZBlockSupportPauseDate = @"NSTimerLYZBlockSupport.PauseDate";
static NSString * const NSTimerLYZBlockSupportPreviousFireDate = @"NSTimerLYZBlockSupport.PreviousFireDate";

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
    [self setAssociateValue:[NSDate date] withKey:(__bridge const void *)NSTimerLYZBlockSupportPauseDate];
    [self setAssociateValue:self.fireDate withKey:(__bridge const void *)NSTimerLYZBlockSupportPreviousFireDate];

    self.fireDate = [NSDate distantFuture];
}

- (void)resumeTimer
{
    NSDate *pauseDate = [self getAssociatedValueForKey:(__bridge const void *)NSTimerLYZBlockSupportPauseDate];
    NSDate *previousFireDate = [self getAssociatedValueForKey:(__bridge const void *)NSTimerLYZBlockSupportPreviousFireDate];
    
    const NSTimeInterval pauseTime = fabs([pauseDate timeIntervalSinceNow]);
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate];
}

#pragma mark - LYZBlockSupport helper

+ (void)onTimerFired:(NSTimer *)timer;
{
    dispatch_block_t block = timer.userInfo;
    if (block) {
        block();
    }
}

@end
