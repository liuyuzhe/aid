//
//  AidCarouselCollectionCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/29.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidCarouselCollectionCell.h"

@interface AidCarouselCollectionCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end


@implementation AidCarouselCollectionCell

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return  self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - life cycle helper

-(void)setUpUI
{
    UIImageView * imageView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:imageView];
    
    self.imageView = imageView;
    
}

#pragma mark - override super

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
}

#pragma mark - getters and setters

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    
}

@end
