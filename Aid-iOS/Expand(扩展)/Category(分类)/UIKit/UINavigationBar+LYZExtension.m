//
//  UINavigationBar+LYZExtension.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/8.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "UINavigationBar+LYZExtension.h"
#import "NSObject+LYZRuntimeMethod.h"

@interface UINavigationBar ()

@property (nonatomic, strong) UIView  *backgroundView;

@property (nonatomic, strong) UIImage *originBackgroundImage;
@property (nonatomic, strong) UIImage *originShadowImage;
@property (nonatomic, assign) BOOL originIsTranslucent;

@end


@implementation UINavigationBar (LYZExtension)

- (void)lyz_setBackgroundColor:(UIColor *)color
{
    if (! self.backgroundView) {
        self.originBackgroundImage = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
        self.originShadowImage     = self.shadowImage;
        self.originIsTranslucent   = self.translucent;
        
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:nil];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        bgView.userInteractionEnabled = NO;
        [self insertSubview:bgView atIndex:0];
        
        self.backgroundView = bgView;
        self.translucent       = YES;
        
    }
    self.backgroundView.backgroundColor = color;
}

- (void)lyz_setBackgroundAlpha:(CGFloat)alpha
{
    [self lyz_setBackgroundColor:[self.barTintColor colorWithAlphaComponent:alpha]];
}

- (void)lyz_reset
{
    [self setBackgroundImage:self.originBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:self.originShadowImage];
    [self setTranslucent:self.originIsTranslucent];
    
    [self.backgroundView removeFromSuperview];
    self.originBackgroundImage = nil;
    self.originShadowImage     = nil;
    self.backgroundView        = nil;
}

#pragma mark- getters & setters

- (UIView *)backgroundView
{
    return [self getAssociatedValueForKey:@selector(backgroundView)];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [self setAssociateValue:backgroundView withKey:@selector(backgroundView)];
}

- (UIImage *)originBackgroundImage
{
    return [self getAssociatedValueForKey:@selector(originBackgroundImage)];
}

- (void)setOriginBackgroundImage:(UIImage *)originBackgroundImage
{
    [self setAssociateValue:originBackgroundImage withKey:@selector(originBackgroundImage)];
}

- (UIImage *)originShadowImage
{
    return [self getAssociatedValueForKey:@selector(originShadowImage)];
}

- (void)setOriginShadowImage:(UIImage *)originShadowImage
{
    [self setAssociateValue:originShadowImage withKey:@selector(originShadowImage)];
}

- (BOOL)originIsTranslucent
{
    return [[self getAssociatedValueForKey:@selector(originIsTranslucent)] boolValue];
}

- (void)setOriginIsTranslucent:(BOOL)originIsTranslucent
{
    [self setAssociateValue:@(originIsTranslucent) withKey:@selector(originIsTranslucent)];
}

@end
