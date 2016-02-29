//
//  LYZHorizontalButton.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/21.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "LYZHorizontalButton.h"

@implementation LYZHorizontalButton

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
    
    self.imageView.left = 0;
    self.imageView.top = (self.height - self.imageView.height) / 2;
    self.imageView.width = self.imageView.width;
    self.imageView.height = self.imageView.height;
    
    self.titleLabel.left = self.imageView.width;
    self.titleLabel.top = (self.height - self.titleLabel.height) / 2;
    self.titleLabel.width = self.width - self.imageView.width;
    self.titleLabel.height = self.titleLabel.height;
}

@end
