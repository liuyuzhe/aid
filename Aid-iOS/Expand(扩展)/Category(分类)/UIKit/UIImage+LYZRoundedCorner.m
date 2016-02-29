//
//  UIImage+LYZRoundedCorner.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/26.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "UIImage+LYZRoundedCorner.h"
#import "UIImage+LYZExtension.h"
#import "LYZMathMethod.h"

@implementation UIImage (LYZRoundedCorner)

- (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    return [UIImage imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:self withContentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius withContentMode:(UIViewContentMode)contentMode
{
    return [UIImage imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:self withContentMode:contentMode];
}

+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    return [UIImage imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius andColor:(UIColor *)color
{
    return [UIImage imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:color backgroundImage:nil withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode
{
    return [UIImage imageWithRoundedCornersAndSize:sizeToFit LYZRadius:LYZRadiusMake(radius, radius, radius, radius) borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
}

+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit LYZRadius:(LYZRadius)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode
{
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGFloat halfBorderWidth = borderWidth / 2;
    //设置上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框大小
    CGContextSetLineWidth(context, borderWidth);
    //去锯齿处理
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    //边框颜色
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    //矩形填充颜色
    if (backgroundImage) {
        backgroundImage = [backgroundImage scaleToSize:(CGSize){sizeToFit.width, sizeToFit.height} withContentMode:contentMode];
        backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    } else {
        backgroundColor = [UIColor whiteColor];
    }
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGFloat height = sizeToFit.height;
    CGFloat width = sizeToFit.width;
    
    CGContextMoveToPoint(context, width - halfBorderWidth, radius.topRightRadius + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius.bottomRightRadius  - halfBorderWidth, height - halfBorderWidth, radius.bottomRightRadius);  // 右下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius.bottomLeftRadius - halfBorderWidth, radius.bottomLeftRadius); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius.topLeftRadius); // 左上角
    CGContextAddArcToPoint(context, width , halfBorderWidth, width - halfBorderWidth, radius.topRightRadius + halfBorderWidth, radius.topRightRadius); // 右上角
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

@end
