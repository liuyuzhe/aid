//
//  AidAddThemeView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidAddThemeView.h"
#import "Masonry.h"

@interface AidAddThemeView ()

@property (nonatomic, strong) UIButton *addButton;

@end


@implementation AidAddThemeView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
        
        [self addSubview:_addButton];
        
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
    [_addButton setTitle:@"新建主题" forState:UIControlStateNormal];
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

#pragma mark - event response

- (void)addButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(addButtonTouched:)]) {
        [self.delegate addButtonTouched:button];
    }
}

@end
