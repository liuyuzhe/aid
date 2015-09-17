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

typedef dispatch_block_t LYZTimerBlock;

@interface NSTimer (LYZBlockSupport)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(LYZTimerBlock)block
                                    repeats:(BOOL)repeats;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                             block:(LYZTimerBlock)block
                           repeats:(BOOL)repeats;

@end
