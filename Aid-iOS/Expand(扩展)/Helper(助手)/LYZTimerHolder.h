//
//  LYZTimerHolder.h
//  AppProject
//
//  Created by 刘育哲 on 15/3/27.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYZTimerHolder;

@protocol LYZTimerHolderDelegate <NSObject>

@optional
- (void)timerDidFire:(LYZTimerHolder *)timeHolder;

@end



@interface LYZTimerHolder : NSObject

@property (nonatomic, assign, readonly, getter=isTimeout) BOOL timeout;
@property (nonatomic, assign, readonly, getter=timeAliveInterval) NSTimeInterval timeAliveInterval;

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<LYZTimerHolderDelegate>)delegate
           repeats:(BOOL)repeats;

- (void)stopTimer;

@end
