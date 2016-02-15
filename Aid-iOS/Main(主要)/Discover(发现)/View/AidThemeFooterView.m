//
//  AidThemeFooterView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/3.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidThemeFooterView.h"
#import "AidControlLabelView.h"

@interface AidThemeFooterView ()

@property (nonatomic, strong) NSArray<AidControlLabelView *> *viewArray; /**< view数组 */

@end


@implementation AidThemeFooterView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame viewArray:(NSArray <AidControlLabelView *> *)viewArray
{
    if (self = [super initWithFrame:frame]) {
        _viewArray = viewArray;
        
        [self setupPageSubviews];
        
        [self layoutPageSubviews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    CGFloat heigh;
    for (int i = 0; i < _viewArray.count; ++i) {
        // 背景视图
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(i * self.width / _viewArray.count, 0, self.width / _viewArray.count, self.height)];
        backView.tag = 100 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
        [backView addGestureRecognizer:tap];
        [backView addSubview:_viewArray[i]];
        [self addSubview:backView];
        
        // 分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * self.width / _viewArray.count - 1, (self.height - heigh) / 2, 0.5, heigh)];
        lineView.backgroundColor = [UIColor redColor];
        [self addSubview:lineView];
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
}

#pragma mark - override super

#pragma mark - event response

- (void)OnTapBackView:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag - 100;
    AidControlLabelView *view = _viewArray[index];

    if (view.flagControl.flag == AidFlagControlStateNO) {
        [view.flagControl setFlag:AidFlagControlStateYES withAnimation:YES];
        view.flagControl.selected = YES;
    }
    else if (view.flagControl.flag == AidFlagControlStateYES) {
        [view.flagControl setFlag:AidFlagControlStateNO withAnimation:YES];
        view.flagControl.selected = NO;
    }

//    if ([self.delegate respondsToSelector:@selector(didSelectAtIndexDiscountCell:)]) {
//        [self.delegate didSelectAtIndexDiscountCell:index];
//    }
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
