//
//  UIButton+LYZExtension.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/3/1.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LYZExtension)

+ (UIButton *)initWithNormalImageName:(NSString *)imageName target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height;
+ (UIButton *)initWithNormalImageName:(NSString *)normalImageName highlightImageName:(NSString *)highlightImageName isBackground:(BOOL)isBackground target:(id)target action:(SEL)action;
+ (UIButton *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

@end


@interface UIButton (LYZCommonButton)

+ (UIButton *)addButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)menuButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)shareButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)backButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)moreButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)noticeButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)noticeDotButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)infomationButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)arrowCloseButtonWithTarget:(id)target action:(SEL)action;

@end
