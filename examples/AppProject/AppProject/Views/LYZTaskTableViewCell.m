//
//  LYZTaskTableViewCell.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZTaskTableViewCell.h"
#import "Masonry.h"

@interface LYZTaskTableViewCell ()

@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *completeButton;

@end


@implementation LYZTaskTableViewCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_starButton];
        [self.contentView addSubview:_completeButton];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _title = [[UILabel alloc] init];
    
    _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    #pragma unused (weakSelf)
    #warning weakSelf
//    #error weakSelf
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
{
    [super setEditing:editing animated:animated];
}

#pragma mark - event response

- (void)starButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(starButtonTouched:)]) {
        [self.delegate starButtonTouched:button];
    }
}

- (void)completeButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(completeButtonTouched:)]) {
        [self.delegate completeButtonTouched:button];
    }
}

@end
