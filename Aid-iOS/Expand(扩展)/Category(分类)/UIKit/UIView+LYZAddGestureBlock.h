//
//  UIView+LYZAddGestureBlock.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddGestureBlock)();

@interface UIView (LYZAddGestureBlock) <UIGestureRecognizerDelegate>

- (void)tapped:(AddGestureBlock)block;
- (void)doubleTapped:(AddGestureBlock)block;
- (void)twoFingerTapped:(AddGestureBlock)block;
- (void)touchedDown:(AddGestureBlock)block;
- (void)touchedUp:(AddGestureBlock)block;

@end
