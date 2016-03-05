//
//  UIView+LYZAddGestureBlock.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AidGestureRecognizerSuccess)();

@interface UIView (LYZAddGestureBlock) <UIGestureRecognizerDelegate>

/** 单指轻敲 */
- (void)tappedGesture:(AidGestureRecognizerSuccess)block;
/** 单指轻敲两次 */
- (void)doubleTappedGesture:(AidGestureRecognizerSuccess)block;
/** 双指轻敲 */
- (void)twoFingerTappedGesture:(AidGestureRecognizerSuccess)block;
/** 按下手势 */
- (void)touchedDownGesture:(AidGestureRecognizerSuccess)block;
/** 抬起手势 */
- (void)touchedUpGesture:(AidGestureRecognizerSuccess)block;

/** 旋转手势 */
- (void)rotationGesture:(AidGestureRecognizerSuccess)block;
/** 缩放手势 */
- (void)pinchGesture:(AidGestureRecognizerSuccess)block;
/** 拖拽手势 */
- (void)panGesture:(AidGestureRecognizerSuccess)block;

@end
