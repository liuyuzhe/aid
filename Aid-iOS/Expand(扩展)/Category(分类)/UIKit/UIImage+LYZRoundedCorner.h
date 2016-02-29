//
//  UIImage+LYZRoundedCorner.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/26.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  https://github.com/raozhizhen/JMRoundedCorner
 */
typedef struct {
    CGFloat topLeftRadius;
    CGFloat topRightRadius;
    CGFloat bottomLeftRadius;
    CGFloat bottomRightRadius;
} LYZRadius;

static inline LYZRadius LYZRadiusMake(CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius)
{
    LYZRadius radius;
    radius.topLeftRadius = topLeftRadius;
    radius.topRightRadius = topRightRadius;
    radius.bottomLeftRadius = bottomLeftRadius;
    radius.bottomRightRadius = bottomRightRadius;
    return radius;
}

@interface UIImage (LYZRoundedCorner)

- (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius withContentMode:(UIViewContentMode)contentMode;
+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius andColor:(UIColor *)color;
+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode;
+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit LYZRadius:(LYZRadius)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode;

@end
