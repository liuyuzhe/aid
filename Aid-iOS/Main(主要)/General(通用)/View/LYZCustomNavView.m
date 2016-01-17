//
//  LYZCustomNavView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZCustomNavView.h"

@interface LYZCustomNavView ()

@property (nonatomic, strong) UIButton *cancelButton; /**< 取消按钮 */
@property (nonatomic, strong) UIButton *completeButton; /**< 完成按钮 */

@end


@implementation LYZCustomNavView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
        
        [self addSubview:_cancelButton];
        [self addSubview:_completeButton];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    // 取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 完成按钮
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _completeButton.showsTouchWhenHighlighted = YES; // 按下会发光
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(20);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).offset(-20);
    }];
}

#pragma mark - override super

#pragma mark - event response

- (void)cancelButtonAction:(UIButton *)button
{
    if (self.cancelButtonTouched) {
        self.cancelButtonTouched(button);
    }
}

- (void)completeButtonAction:(UIButton *)button
{
    if (self.completeButtonTouched) {
        self.completeButtonTouched(button);
    }
}

@end
