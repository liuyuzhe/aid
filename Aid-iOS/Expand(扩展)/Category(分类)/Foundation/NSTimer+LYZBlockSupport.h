//
//  NSTimer+LYZBlockSupport.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 sample code:
 
 _weak ClassName *weakSelf = self;
 NSTimer *timer = [scheduledTimerWithTimeInterval:1.0
 block:^{ ClassName * strongSelf = weakSelf;
 [strongSelf doSomething] }
 repeats:YES];
 
 NSTimer *timer = [timerWithTimeInterval:1.0
 block:^{ ClassName * strongSelf = weakSelf;
 [strongSelf doSomething] }
 repeats:YES];
 [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
 
 [timer invalidate];
 
 */
@interface NSTimer (LYZBlockSupport)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(dispatch_block_t)block
                                    repeats:(BOOL)repeats;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                             block:(dispatch_block_t)block
                           repeats:(BOOL)repeats;

- (void)pauseTimer;
- (void)resumeTimer;

@end
