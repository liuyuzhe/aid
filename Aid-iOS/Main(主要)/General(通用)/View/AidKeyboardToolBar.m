//
//  AidKeyboardToolBar.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/20.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidKeyboardToolBar.h"

@interface AidKeyboardToolBar ()

@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIBarButtonItem *fixedSpace;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;

@end


@implementation AidKeyboardToolBar

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.barStyle = UIBarStyleDefault; // 风格
        self.translucent = YES; // 是否半透明
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth);
        [self sizeToFit];
        
        [self setupPageSubviews];
        
        self.items = @[_previousButton, _fixedSpace, _nextButton, _flexibleSpace, _doneButton];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _previousButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(previousButtonAction:)];
    _nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(nextButtonAction:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
    
    _fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _fixedSpace.width = 22.0;
    _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

#pragma mark - override super

#pragma mark - event response

- (void)previousButtonAction:(UIBarButtonItem *)item
{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardToolBar:didClickPreviousItem:)]) {
        [self.keyboardDelegate keyboardToolBar:self didClickPreviousItem:item];
    }
}

- (void)nextButtonAction:(UIBarButtonItem *)item
{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardToolBar:didClickNextItem:)]) {
        [self.keyboardDelegate keyboardToolBar:self didClickNextItem:item];
    }
}

- (void)doneButtonAction:(UIBarButtonItem *)item
{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardToolBar:didClickDoneItem:)]) {
        [self.keyboardDelegate keyboardToolBar:self didClickDoneItem:item];
    } 
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
