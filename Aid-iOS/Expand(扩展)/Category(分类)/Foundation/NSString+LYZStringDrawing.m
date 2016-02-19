//
//  NSString+LYZStringDrawing.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "NSString+LYZStringDrawing.h"

@implementation NSString (LYZStringDrawing)

- (CGFloat)widthForFont:(UIFont *)font
{
    CGSize size = [self sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width
{
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    
    if (! font) {
        font = [UIFont systemFontOfSize:12];
    }
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    
    return result;
}

@end
