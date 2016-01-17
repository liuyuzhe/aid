//
//  UINavigationBar+LYZExtension.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/8.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (LYZExtension)

/** 设置导航栏背景颜色 */
- (void)lyz_setBackgroundColor:(UIColor *)color;

/** 设置导航栏透明度 */
- (void)lyz_setBackgroundAlpha:(CGFloat)alpha;

/** 重置导航栏的状态，恢复到初始时的状态 */
- (void)lyz_reset;

@end
