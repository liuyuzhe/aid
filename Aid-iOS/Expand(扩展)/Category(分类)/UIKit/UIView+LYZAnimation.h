//
//  UIView+LYZAnimation.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/10.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYZAnimation)

/** 淡入动画 */
- (void)fadeInWithTime:(NSTimeInterval)time;
/** 淡出动画 */
- (void)fadeOutWithTime:(NSTimeInterval)time;
/** 缩放动画 */
- (void)scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal;
/** 旋转动画 */
- (void)RevolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta;

#pragma mark -

/** 暂停动画 */
- (void)pauseAnimation;
/** 继续动画 */
- (void)resumeAnimation;

@end
