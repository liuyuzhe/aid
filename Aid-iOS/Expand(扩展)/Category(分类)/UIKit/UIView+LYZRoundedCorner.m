//
//  UIView+LYZRoundedCorner.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/26.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "UIView+LYZRoundedCorner.h"
#import "NSObject+LYZRuntimeMethod.h"

@implementation UIView (LYZRoundedCorner)

#pragma mark - public methods

- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    [self setCornerRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor
{
    [self setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image
{
    [self setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode
{
    [self setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode
{
    [self setLYZRadius:LYZRadiusMake(radius, radius, radius, radius) withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode];
}

#pragma mark -

- (void)setLYZRadius:(LYZRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    [self setLYZRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setLYZRadius:(LYZRadius)radius withBackgroundColor:(UIColor *)backgroundColor
{
    [self setLYZRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
}

- (void)setLYZRadius:(LYZRadius)radius withImage:(UIImage *)image
{
    [self setLYZRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)setLYZRadius:(LYZRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode
{
    [self setLYZRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)setLYZRadius:(LYZRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode
{
    [self setNeedsLayout];
    
    NSValue *radiusValue = [NSValue valueWithBytes:&radius objCType:@encode(LYZRadius)];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"radius"] = radiusValue;
    
    if (borderColor)
        dic[@"borderColor"] = borderColor;
    else
        dic[@"borderColor"] = NSNull.null;
    
    dic[@"borderWidth"] = [NSNumber numberWithFloat:borderWidth];
    
    if (backgroundColor)
        dic[@"backgroundColor"] = backgroundColor;
    else
        dic[@"backgroundColor"] = NSNull.null;
    
    if (backgroundImage)
        dic[@"backgroundImage"] = backgroundImage;
    else
        dic[@"backgroundImage"] = NSNull.null;
    
    dic[@"contentMode"] = [NSNumber numberWithFloat:contentMode];
    
    [self performSelector:@selector(setRadius:) withObject:dic afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}

#pragma mark - private methods

- (void)setRadius:(NSMutableDictionary *)dic
{
    LYZRadius radius;
    [dic[@"radius"] getValue:&radius];
    UIColor *borderColor;
    UIColor *backgroundColor;
    UIImage *backgroundImage;
    
    if (dic[@"borderColor"] == NSNull.null)
        borderColor = nil;
    else
        borderColor = dic[@"borderColor"];
    
    if (dic[@"backgroundColor"] == NSNull.null)
        backgroundColor = nil;
    else
        backgroundColor = dic[@"backgroundColor"];
    
    if (dic[@"backgroundImage"] == NSNull.null)
        backgroundImage = nil;
    else
        backgroundImage = dic[@"backgroundImage"];
    
    [self setLYZRadius:radius withBorderColor:borderColor borderWidth:[dic[@"borderWidth"] floatValue] backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:[dic[@"contentMode"] integerValue] size:self.bounds.size];
}

- (void)setLYZRadius:(LYZRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
    UIImage *image = [UIImage imageWithRoundedCornersAndSize:size LYZRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
    if ([self isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)self).image = image;
    }
    else if ([self isKindOfClass:[UIButton class]] && backgroundImage) {
        [((UIButton *)self) setBackgroundImage:image forState:UIControlStateNormal];
    }
    else {
        self.roundedCornerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.roundedCornerView.image = image;
        [self addSubview:self.roundedCornerView];
        [self sendSubviewToBack:self.roundedCornerView];
    }
}

#pragma mark - getters and setters

- (UIImageView *)roundedCornerView
{
    return [self getAssociatedValueForKey:@selector(roundedCornerView)];
}

- (void)setRoundedCornerView:(UIImageView *)roundedCornerView
{
    [self setAssociateValue:roundedCornerView withKey:@selector(roundedCornerView)];
}

@end
