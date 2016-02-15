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
 
 __weak typeof(self) weakSelf = self;
 NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
 block:^{ typeof(self) * strongSelf = weakSelf;
 [strongSelf doSomething]; }
 repeats:YES];
 
 NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
 block:^{ typeof(self) * strongSelf = weakSelf;
 [strongSelf doSomething]; }
 repeats:YES];
 [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
 [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // 当滑动界面时，系统为了更好地处理UI事件和滚动显示，主线程runloop会暂时停止处理一些其它事件，这时主线程中运行的NSTimer就会被暂停。改变NSTimer运行的mode为NSRunLoopCommonModes，NSTimer将不会被暂停。
 
 [timer invalidate];
 timer = nil;
 
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
