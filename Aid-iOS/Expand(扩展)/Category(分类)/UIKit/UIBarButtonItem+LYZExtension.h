//
//  UIBarButtonItem+LYZExtension.h
//  
//
//  Created by 刘育哲 on 15/11/17.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LYZExtension)

+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height;

+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

@end
