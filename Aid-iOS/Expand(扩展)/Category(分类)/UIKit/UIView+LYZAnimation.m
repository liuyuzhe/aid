//
//  UIView+LYZAnimation.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/10.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "UIView+LYZAnimation.h"

@implementation UIView (LYZAnimation)

- (void)fadeInWithTime:(NSTimeInterval)time
{
    self.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOutWithTime:(NSTimeInterval)time
{
    self.alpha = 1;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal
{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeScale(scal,scal);
    }];
}

- (void)RevolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta
{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeRotation(delta);
    }];
}

#pragma mark -

- (void)pauseAnimation
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resumeAnimation
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

@end
