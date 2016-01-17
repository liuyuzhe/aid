//
//  AidDisplayTitleLabel.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/27.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidDisplayTitleLabel.h"

@implementation AidDisplayTitleLabel

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

#pragma mark - override super

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.fillColor set];
    
    rect.size.width = rect.size.width * self.progress;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

#pragma mark - getters and setters

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

@end
