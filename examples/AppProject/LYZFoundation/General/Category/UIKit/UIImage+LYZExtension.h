//
//  UIImage+LYZExtension.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/15.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYZExtension)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/** 子图像 */
- (UIImage *)subimageInRect:(CGRect)rect;

/** 图像旋转 @param radians 旋转弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
/** 图像旋转 @param radians 旋转角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
/** 图像变换 */
- (UIImage *)imageWithTransform:(CGAffineTransform)transform;

/** 图像缩放 */
- (UIImage *)imageWithSize:(CGSize)size;

/** 调整方向 */
- (UIImage *)fixOrientation;

@end
