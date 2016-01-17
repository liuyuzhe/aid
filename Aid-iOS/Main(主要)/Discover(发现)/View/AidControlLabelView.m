//
//  AidControlLabelView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/4.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidControlLabelView.h"

@implementation AidControlLabelView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
        
        [self addSubview:_flagControl];
        [self addSubview:_label];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _flagControl = [[AidFlagControl alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _flagControl.noStateImage = [UIImage imageNamed:@"bg_keyboard6_selected"];
    _flagControl.yesStateImage = [UIImage imageNamed:@""@"bg_keyboard7"];
//    [_flagControl addTarget:self action:@selector(flagControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 20, 10)];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
}

#pragma mark - override super

#pragma mark - event response

- (void)flagControlAction:(AidFlagControl *)flagControl
{
    if (flagControl.flag == AidFlagControlStateNO) {
        [flagControl setFlag:AidFlagControlStateYES withAnimation:YES];
        flagControl.selected = YES;
    }
    else if (flagControl.flag == AidFlagControlStateYES) {
        [flagControl setFlag:AidFlagControlStateNO withAnimation:YES];
        flagControl.selected = NO;
    }
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
