//
//  NSString+LYZStringDrawing.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LYZStringDrawing)

/** 获取文本占据宽度 */
- (CGFloat)widthForFont:(UIFont *)font;
/** 获取文本占据高度 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;
/** 获取文本占据大小 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end
