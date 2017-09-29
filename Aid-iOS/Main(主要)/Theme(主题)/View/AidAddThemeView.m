//
//  AidAddThemeView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidAddThemeView.h"

#import "Masonry.h"

@interface AidAddThemeView () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *themeNameTextField; /**< 主题名称文本框 */
@property (nonatomic, strong) UITextView *themeDescribeTextView; /**< 主题描述文本视图 */
//@property (nonatomic, strong) UIButton *coverImageButton; /**< 设置封面按钮 */
@property (nonatomic, strong) UIButton *cancelButton; /**< 取消按钮 */
@property (nonatomic, strong) UIButton *completeButton; /**< 完成按钮 */

@end


@implementation AidAddThemeView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
        
        [self addSubview:_themeNameTextField];
        [self addSubview:_themeDescribeTextView];
//        [self addSubview:_coverImageButton];
        [self addSubview:_cancelButton];
        [self addSubview:_completeButton];
        
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
    // 自定义键盘
    UIToolbar * keyBoardToolBar = [[UIToolbar alloc] init];
    keyBoardToolBar.barStyle = UIBarStyleDefault; // 风格
    keyBoardToolBar.translucent = YES; // 半透明
    [keyBoardToolBar sizeToFit];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemAction:)];
    UIBarButtonItem *addNewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneItemAction:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    keyBoardToolBar.items = @[cancelItem, spaceItem, addNewItem];
    
    // 主题名称
    _themeNameTextField = [[UITextField alloc] init];
    _themeNameTextField.font = [UIFont boldSystemFontOfSize:18]; // 文本字体
    _themeNameTextField.textColor = [UIColor greenColor]; // 文本颜色
    _themeNameTextField.textAlignment = NSTextAlignmentCenter; // 文本对齐方式
    _themeNameTextField.borderStyle = UITextBorderStyleLine; // 边框类型
    _themeNameTextField.placeholder = @"请输入主题名称"; // 水印提示
    _themeNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
    _themeNameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
    _themeNameTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    _themeNameTextField.returnKeyType = UIReturnKeyDone; // return键类型
    _themeNameTextField.backgroundColor = [UIColor redColor]; // 背景颜色
    _themeNameTextField.inputAccessoryView = keyBoardToolBar; //自定义键盘视图
    _themeNameTextField.delegate = self;
    
    // 主题描述
    _themeDescribeTextView = [[UITextView alloc] init];
    _themeDescribeTextView.font = [UIFont boldSystemFontOfSize:18]; // 文本字体
    _themeDescribeTextView.textColor = [UIColor greenColor]; // 文本颜色
    _themeDescribeTextView.textAlignment = NSTextAlignmentCenter; // 文本对齐方式
    _themeDescribeTextView.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
    _themeDescribeTextView.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
    _themeDescribeTextView.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    _themeDescribeTextView.returnKeyType = UIReturnKeyDone; // return键类型
    _themeDescribeTextView.dataDetectorTypes = UIDataDetectorTypeNone; // 显示数据类型的连接模式
    _themeDescribeTextView.scrollEnabled = NO;    // 当文字超过视图的边框时是否允许滑动，默认为“YES”
    _themeDescribeTextView.backgroundColor = [UIColor blueColor]; // 背景颜色
    _themeDescribeTextView.inputAccessoryView = keyBoardToolBar; //自定义键盘视图
    _themeDescribeTextView.delegate = self;
    
    // 取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 完成按钮
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.showsTouchWhenHighlighted = YES; // 按下会发光
//    _completeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    _completeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [_completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_themeNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(0);
        make.height.mas_equalTo(@180);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
    }];
    
    [_themeDescribeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_themeNameTextField.mas_bottom).with.offset(20);
        make.height.mas_equalTo(@200);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.equalTo(_themeNameTextField);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_themeDescribeTextView.mas_bottom).with.offset(20);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-20);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
//        make.right.equalTo(_completeButton.mas_left).with.offset(-20);
//        make.width.equalTo(_completeButton);
    }];
    
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_themeDescribeTextView.mas_bottom).with.offset(20);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-20);
//        make.left.equalTo(_cancelButton.mas_right).with.offset(20);
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
//        make.width.equalTo(_cancelButton);
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.themeNameTextField == textField) {
        [self.themeNameTextField resignFirstResponder];
    }
    
    return YES;
}
#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

#pragma mark - event response

- (void)cancelButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(cancelButtonTouched:)]) {
        [self.delegate cancelButtonTouched:button];
    }
}

- (void)completeButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(completeButtonTouched:)]) {
        [self.delegate completeButtonTouched:button];
    }
}

@end
