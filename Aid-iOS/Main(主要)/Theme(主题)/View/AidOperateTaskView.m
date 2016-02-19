//
//  AidOperateTaskView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/25.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidOperateTaskView.h"

#import "LYZVerticalButton.h"
#import "UIView+LYZMasonyCategory.h"

@interface AidOperateTaskView ()

@property (nonatomic, strong) NSArray<NSString *> *imageArray;
@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@end


@implementation AidOperateTaskView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray <NSString *> *)imageNames titleNames:(NSArray <NSString *> *)titleNames
{
    if (self = [super initWithFrame:frame]) {
        _imageArray = [[NSArray alloc] initWithArray:imageNames];
        _titleArray = [[NSArray alloc] initWithArray:titleNames];
        
        [self setupPageSubviews];
        
        [self layoutPageSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame imageNames:nil titleNames:nil];
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - public methods

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    CGFloat width = self.width / _imageArray.count;
    CGFloat height = self.height;
    
    for (int i = 0; i < _imageArray.count; ++i) {
        LYZVerticalButton *button = [[LYZVerticalButton alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        button.tag = 100 + i;
        
        UIImage *image = [[UIImage imageNamed:_imageArray[i]] imageWithSize:CGSizeMake(30, 30)]; // 图像缩放
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)layoutPageSubviews
{
}

#pragma mark - override super

#pragma mark - event response

- (void)itemButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(multipleButtonTouched:withIndex:)]) {
        [self.delegate multipleButtonTouched:button withIndex:button.tag - 100];
    }
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
