//
//  LYZVerticalButton.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/21.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "LYZVerticalButton.h"

@implementation LYZVerticalButton

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)awakeFromNib
{
    [self setupPageSubviews];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    self.imageView.contentMode = UIViewContentModeCenter;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
}

#pragma mark - override super

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.left = (self.width - self.imageView.width) / 2;
    self.imageView.top = 0;
    self.imageView.width = self.imageView.width;
    self.imageView.height = self.imageView.height;
    
    self.titleLabel.left = (self.width - self.titleLabel.width) / 2;
    self.titleLabel.top = self.imageView.height;
    self.titleLabel.width = self.titleLabel.width;
    self.titleLabel.height = self.height - self.imageView.height;
}

@end
