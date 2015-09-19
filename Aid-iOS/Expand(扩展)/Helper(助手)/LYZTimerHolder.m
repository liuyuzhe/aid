//
//  LYZTimerHolder.m
//  AppProject
//
//  Created by 刘育哲 on 15/3/27.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZTimerHolder.h"

@interface LYZTimerHolder ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, weak) id<LYZTimerHolderDelegate> timerDelegate;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign, readwrite, getter=isTimeout) BOOL timeout;
@property (nonatomic, assign, readwrite, getter=timeAliveInterval) NSTimeInterval timeAliveInterval;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@end


@implementation LYZTimerHolder

#pragma mark - LYZTimerHolder method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeout = NO;
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
}

#pragma mark - LYZTimerHolder public

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<LYZTimerHolderDelegate>)delegate
           repeats:(BOOL)repeats
{
    self.startTime = [NSDate date];
    self.timeoutInterval = (seconds > 0.0) ? seconds : 0.1;
    
    self.timerDelegate = delegate;
    self.repeats = repeats;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:repeats];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    self.timerDelegate = nil;
    self.startTime = nil;
}

#pragma mark - LYZTimerHolder helper

- (void)onTimer:(NSTimer *)timer
{
    self.timeout = YES;
    
    if (! self.repeats) {
        self.timer = nil;
    }
    if ([self.timerDelegate respondsToSelector:@selector(timerDidFire:)]) {
        [self.timerDelegate timerDidFire:self];
    }
}

#pragma mark - LYZTimerHolder property

- (BOOL)isTimeout
{
    if (self.timeAliveInterval > self.timeoutInterval) {
        self.timeout = YES;
    }
    
    return self.timeout;
}

- (NSTimeInterval)timeAliveInterval
{
    if (! self.startTime) {
        return 0.0;
    }
    
    return fabs([self.startTime timeIntervalSinceNow]);
}

@end
