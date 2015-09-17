//
//  LYZAddListTableViewCell.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZAddListTableViewCell.h"
#import "Masonry.h"

@interface LYZAddListTableViewCell ()

@end


@implementation LYZAddListTableViewCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_textField];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"Add new project...";
    _textField.textColor = [UIColor greenColor];
    _textField.font = [UIFont boldSystemFontOfSize:18];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.enablesReturnKeyAutomatically = YES;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    
    UIToolbar * keyBoardToolBar = [[UIToolbar alloc] init];
    keyBoardToolBar.barStyle = UIBarStyleDefault;
    keyBoardToolBar.translucent = YES;
    [keyBoardToolBar sizeToFit];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemAction:)];
    UIBarButtonItem *addNewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneItemAction:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    keyBoardToolBar.items = @[cancelItem, spaceItem, addNewItem];
    
    _textField.inputAccessoryView = keyBoardToolBar;
    //    _addItemCell.textField.rightView = self.starButton;
    //    _textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
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

- (void)cancelItemAction:(UIBarButtonItem *)barButton;
{
    if ([self.delegate respondsToSelector:@selector(cancelItemSelected:)]) {
        [self.delegate cancelItemSelected:barButton];
    }
}

- (void)doneItemAction:(UIBarButtonItem *)barButton;
{
    if ([self.delegate respondsToSelector:@selector(doneItemSelected:)]) {
        [self.delegate doneItemSelected:barButton];
    }
}

@end
