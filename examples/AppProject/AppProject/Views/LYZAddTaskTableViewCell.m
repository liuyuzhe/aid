//
//  LYZAddTaskTableViewCell.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZAddTaskTableViewCell.h"
#import "Masonry.h"

@interface LYZAddTaskTableViewCell ()

@end


@implementation LYZAddTaskTableViewCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_addButton];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.showsTouchWhenHighlighted = YES;
    _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addButton setTitle:@"Add new task..." forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf).with.mas_offset(CGSizeMake(10, 10));
    }];
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
{
//    [super setEditing:editing animated:animated];
}

#pragma mark - event response

- (void)addButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(addButtonTouched:)]) {
        [self.delegate addButtonTouched:button];
    }
}

@end

