//
//  UIButton+LYZExtension.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/3/1.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "UIButton+LYZExtension.h"

@implementation UIButton (LYZExtension)

+ (UIButton *)initWithNormalImageName:(NSString *)imageName target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height
{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width, height);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)initWithNormalImageName:(NSString *)normalImageName highlightImageName:(NSString *)highlightImageName isBackground:(BOOL)isBackground target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    if (isBackground) {
        [button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }else{
        [button setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    //    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end


@implementation UIButton (LYZCommonButton)

+ (UIButton *)menuButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_menu_default" highlightImageName:@"icon_menu_focus" isBackground:NO target:target action:action];
}

+ (UIButton *)shareButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_share_default" highlightImageName:@"icon_share_focus" isBackground:NO target:target action:action];
}

+ (UIButton *)backButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_back_default" highlightImageName:@"icon_back_focus" isBackground:NO target:target action:action];
}

+ (UIButton *)moreButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_more_default" highlightImageName:@"icon_more_focus" isBackground:NO target:target action:action];
}


+ (UIButton *)noticeButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_news_default" highlightImageName:@"icon_news_focus" isBackground:NO target:target action:action];
}

+ (UIButton *)noticeDotButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_news_dot_default" highlightImageName:@"icon_news_dot_focus" isBackground:NO target:target action:action];
}

+ (UIButton *)infomationButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_info_default" highlightImageName:@"icon_info_focus" isBackground:NO target:target action:action];
}

+ (UIButton *)arrowCloseButtonWithTarget:(id)target action:(SEL)action
{
    return [self initWithNormalImageName:@"icon_back_bottom_default" highlightImageName:@"icon_back_bottom_focus" isBackground:NO target:target action:action];
}

@end