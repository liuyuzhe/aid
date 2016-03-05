//
//  UITextField+LYZExtension.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/3/4.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "UITextField+LYZExtension.h"

static NSString *const LYZShakeAnimation = @"shakeAnimation";

@implementation UITextField (LYZExtension)

- (void)shakeAnimation
{
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrame.duration = 0.3;
    CGFloat x = self.layer.position.x;
    keyFrame.values = @[@(x - 30), @(x - 30), @(x + 20), @(x - 20), @(x + 10), @(x - 10), @(x + 5), @(x - 5)];
    [self.layer addAnimation:keyFrame forKey:LYZShakeAnimation];
}

@end
