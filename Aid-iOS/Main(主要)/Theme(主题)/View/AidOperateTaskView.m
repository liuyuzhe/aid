//
//  AidOperateTaskView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/25.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidOperateTaskView.h"

#import "LYZVerticalButton.h"

@interface AidOperateTaskView ()

@property (nonatomic, strong) NSArray<NSString *> *titleArray;
@property (nonatomic, strong) NSArray<NSString *> *imageArray;

@end


@implementation AidOperateTaskView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray <NSString *> *)titleNames imageNames:(NSArray <NSString *> *)imageNames 
{
    if (self = [super initWithFrame:frame]) {
        LYZAssert(imageNames.count == titleNames.count);
        
        _titleArray = [[NSArray alloc] initWithArray:titleNames];
        _imageArray = [[NSArray alloc] initWithArray:imageNames];
        
        [self setupPageSubviews];
        
        [self layoutPageSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame titleNames:nil imageNames:nil];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - public methods

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    CGFloat width = self.width / _titleArray.count;
    CGFloat height = self.height;
    
    for (int i = 0; i < _titleArray.count; ++i) {
        LYZVerticalButton *button = [[LYZVerticalButton alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        button.tag = 100 + i;
        
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        UIImage *image = [[UIImage imageNamed:_imageArray[i]] scaleToSize:CGSizeMake(30, 30)]; // 图像缩放
        [button setImage:image forState:UIControlStateNormal];
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
