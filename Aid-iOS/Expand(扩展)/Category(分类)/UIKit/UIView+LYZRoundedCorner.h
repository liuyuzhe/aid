//
//  UIView+LYZRoundedCorner.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/26.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+LYZRoundedCorner.h"

@interface UIView (LYZRoundedCorner)

/** 给view设置一个圆角边框 */
- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
/** 给view设置一个圆角背景颜色 */
- (void)setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor;
/** 给view设置一个圆角背景图 */
- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image;
/** 给view设置一个contentMode模式的圆角背景图 */
- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;
/** 设置所有属性配置出一个圆角背景图 */
- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode;

#pragma mark -

/** 给view设置一个圆角边框,四个圆角弧度可以不同 */
- (void)setLYZRadius:(LYZRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
/** 给view设置一个圆角背景颜色,四个圆角弧度可以不同 */
- (void)setLYZRadius:(LYZRadius)radius withBackgroundColor:(UIColor *)backgroundColor;
///**给view设置一个圆角背景图,四个圆角弧度可以不同 */
- (void)setLYZRadius:(LYZRadius)radius withImage:(UIImage *)image;
/** 给view设置一个contentMode模式的圆角背景图,四个圆角弧度可以不同 */
- (void)setLYZRadius:(LYZRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;
/** 设置所有属性配置出一个圆角背景图,四个圆角弧度可以不同 */
- (void)setLYZRadius:(LYZRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)color backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode;

@end
