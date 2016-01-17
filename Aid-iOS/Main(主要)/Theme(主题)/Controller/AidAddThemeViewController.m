//
//  AidAddThemeViewController.m
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import "AidAddThemeViewController.h"
#import "AidTaskViewController.h"
#import "UIViewController+AidTakePicture.h"

#import "LYZCustomNavView.h"

#import "AidThemeRecord.h"

@interface AidAddThemeViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) LYZCustomNavView *customNavView; /**< 自定义导航视图 */
@property (nonatomic, strong) UIView *themeView; /**< 主题主视图 */
@property (nonatomic, strong) UIImageView *themeImageView; /**< 主题图片视图 */
@property (nonatomic, strong) UITextField *themeNameTextField; /**< 主题名称文本框 */
@property (nonatomic, strong) UITextField *themeDescribeTextField; /**< 主题描述文本框 */
@property (nonatomic, strong) UILabel *chooseThemeLabel; /**< 选择主题标签 */
@property (nonatomic, strong) UITextView *themeDescribeTextView; /**< 主题描述文本视图 */
//@property (nonatomic, strong) UIButton *coverImageButton; /**< 设置封面按钮 */

@end

                       
@implementation AidAddThemeViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:LYZScreenBounds];
    self.view = contentView;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.customNavView];
    [self.view addSubview:self.themeView];
    [self.themeView addSubview:self.themeImageView];
    [self.themeView addSubview:self.chooseThemeLabel];
    [self.themeView addSubview:self.themeNameTextField];
//    [self.view addSubview:self.themeDescribeTextView];
    
    [self layoutPageSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle helper

- (void)setupPageNavigation
{
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.height.mas_equalTo(AidNavHeadHeigtht);
    }];
    
    [self.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.right.equalTo(weakSelf).with.offset(-20);
        make.top.equalTo(self.customNavView.mas_bottom);
        make.height.mas_equalTo(@190);
    }];
    
    [self.themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.themeView);
        make.bottom.equalTo(self.chooseThemeLabel.mas_top).offset(-5);
    }];
    
    [self.chooseThemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.themeView);
        make.bottom.equalTo(self.themeView).offset(-5);
    }];
    
    [self.themeNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeView).offset(20);
        make.right.equalTo(self.themeView).offset(-20);
        make.centerY.equalTo(self.themeImageView);
    }];
}

#pragma mark - override super

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.themeNameTextField == textField) {
        [self.themeNameTextField resignFirstResponder];
    }
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
    if (self.themeDescribeTextView == textView) {
        [self.themeDescribeTextView resignFirstResponder];
    }
}

#pragma mark - event response

- (void)cancelButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeButtonAction:(UIButton *)button
{
    if ([self.themeNameTextField.text trimBothWhitespace].length <= 0) {
        return;
    }
    
    AidThemeRecord *record = [[AidThemeRecord alloc] init];
    record.name = self.themeNameTextField.text;
    record.describe = self.themeDescribeTextView.text;
    record.imageName = nil;
    record.createTime = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
    record.praiseState = [NSNumber numberWithBool:false];
    
    if ([self.delegate respondsToSelector:@selector(addThemeRecord:)]) {
        [self.delegate addThemeRecord:record];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseTheme
{
    [self imagePickerAction];
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (LYZCustomNavView *)customNavView
{
    if (! _customNavView) {
        _customNavView = [[LYZCustomNavView alloc] init];
        __weak typeof(self) weakSelf = self;
        _customNavView.cancelButtonTouched = ^(UIButton *button) {
            [weakSelf cancelButtonAction:button];
        };
        _customNavView.completeButtonTouched = ^(UIButton *button) {
            [weakSelf completeButtonAction:button];
        };
    }
    return _customNavView;
}

- (UIView *)themeView
{
    if (! _themeView) {
        _themeView = [[UIView alloc] init];
        _themeView.backgroundColor = [UIColor grayColor];
        __weak typeof(self) weakSelf = self;
        [_themeView tapped:^{
            [weakSelf chooseTheme];
        }];
    }
    return _themeView;
}

- (UIImageView *)themeImageView
{
    if (! _themeImageView) {
        _themeImageView = [[UIImageView alloc] init];
        _themeImageView.contentMode = UIViewContentModeScaleToFill;
        _themeImageView.image = [UIImage imageNamed:@"backImage8.jpg"];
    }
    return _themeImageView;
}

- (UILabel *)chooseThemeLabel
{
    if (! _chooseThemeLabel) {
        _chooseThemeLabel = [[UILabel alloc] init];
        _chooseThemeLabel.text = @"设置封面";
        _chooseThemeLabel.textColor = [UIColor darkGrayColor];
        _chooseThemeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _chooseThemeLabel;
}

- (UITextField *)themeNameTextField
{
    if (! _themeNameTextField) {
        _themeNameTextField = [[UITextField alloc] init];
        _themeNameTextField.textColor = [UIColor whiteColor]; // 文本颜色
        _themeNameTextField.font = [UIFont boldSystemFontOfSize:18]; // 文本字体
        _themeNameTextField.textAlignment = NSTextAlignmentCenter; // 文本对齐方式
        _themeNameTextField.borderStyle = UITextBorderStyleRoundedRect; // 边框类型
//        _themeNameTextField.placeholder = @"请输入主题名称"; // 水印提示
        _themeNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入主题名称"
                                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _themeNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
        _themeNameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
        _themeNameTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
        _themeNameTextField.returnKeyType = UIReturnKeyDone; // return键类型
        _themeNameTextField.backgroundColor = [UIColor clearColor]; // 背景颜色
//        _themeNameTextField.inputAccessoryView = self.keyboardToolBar; // 自定义键盘视图
        
        _themeNameTextField.delegate = self;
    }
    return _themeNameTextField;
}

- (UITextView *)themeDescribeTextView
{
    if (! _themeDescribeTextView) {
        _themeDescribeTextView = [[UITextView alloc] init];
        _themeDescribeTextView.textColor = [UIColor greenColor]; // 文本颜色
//        _themeDescribeTextView.font = [UIFont boldSystemFontOfSize:18]; // 文本字体
        _themeDescribeTextView.textAlignment = NSTextAlignmentCenter; // 文本对齐方式
        _themeDescribeTextView.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
        _themeDescribeTextView.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
        _themeDescribeTextView.keyboardType = UIKeyboardTypeDefault; // 键盘类型
        _themeDescribeTextView.returnKeyType = UIReturnKeyDone; // return键类型
        _themeDescribeTextView.dataDetectorTypes = UIDataDetectorTypeNone; // 显示数据类型的连接模式
        _themeDescribeTextView.scrollEnabled = NO;    // 当文字超过视图的边框时是否允许滑动，默认为“YES”
        _themeDescribeTextView.backgroundColor = [UIColor grayColor]; // 背景颜色
//        _themeDescribeTextView.inputAccessoryView = self.keyboardToolBar; // 自定义键盘视图
        _themeDescribeTextView.delegate = self;
    }
    return _themeDescribeTextView;
}

@end
