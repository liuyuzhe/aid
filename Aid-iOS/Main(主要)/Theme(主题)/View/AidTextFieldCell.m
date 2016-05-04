//
//  AidTextFieldCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/6.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidTextFieldCell.h"
#import "Masonry.h"

#import "UITextField+DatePicker.h"

static const CGFloat AidDefaultOffset = 15;
static const CGFloat AidDefaultTitleWidth = 90;

@interface AidTextFieldCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel; /**< 标题标签 */
@property (nonatomic, strong) UITextField *valueTextField; /**< 值文本框 */

@property (nonatomic, strong) UIImageView *moreImageView; /**< 右侧更多 */
@property (nonatomic, strong) UIView *topLineView; /**< 头部分割线 */
@property (nonatomic, strong) UIView *bottomLineView; /**< 底部分割线 */

@end


@implementation AidTextFieldCell

@synthesize valueText = _valueText;

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidTextFieldCell class]);
    AidTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.backgroundColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_valueTextField];
        [self.contentView addSubview:_moreImageView];
        [self.contentView addSubview:_topLineView];
        [self.contentView addSubview:_bottomLineView];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - public methods

- (void)focusTextField
{
    [self.valueTextField becomeFirstResponder];
}

- (void)hideKeyBoard
{
    [self.valueTextField resignFirstResponder];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.text = @" ";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel sizeToFit];
    
    _valueTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _valueTextField.textColor = [UIColor blackColor]; // 文本颜色
    _valueTextField.font = [UIFont systemFontOfSize:16]; // 文本字体
    _valueTextField.textAlignment = NSTextAlignmentLeft; // 文本对齐方式
    _valueTextField.borderStyle = UITextBorderStyleNone; // 边框类型
    _valueTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
    _valueTextField.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
    _valueTextField.returnKeyType = UIReturnKeyDone; // return键类型
    _valueTextField.backgroundColor = [UIColor clearColor]; // 背景颜色
    _valueTextField.delegate = self;
    _valueTextField.datePickerInput = YES;
    
    _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_right_image.png"]];
    _moreImageView.hidden = YES;
    
    _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _topLineView.backgroundColor = [UIColor colorWithWhite:200.0/255.0 alpha:1.0];
    _topLineView.hidden = YES;
    
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLineView.backgroundColor = [UIColor colorWithWhite:200.0/255.0 alpha:1.0];
    _bottomLineView.hidden = YES;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(AidDefaultOffset);
        make.width.mas_equalTo(AidDefaultTitleWidth);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(AidDefaultOffset);
        make.right.equalTo(_moreImageView).offset(-AidDefaultOffset);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-AidDefaultOffset);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//    [super setEditing:editing animated:animated];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    
    return YES;
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setCellStyle:(AidTextFieldCellStyle)cellStyle
{
    _cellStyle = cellStyle;
    
    switch (cellStyle) {
        case AidTextFieldCellStyleName: {
            self.valueTextField.placeholder = @"请输入名称"; // 水印提示
            self.valueTextField.clearButtonMode = UITextFieldViewModeNever; // 清除按钮显示模式
            self.valueTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
            break;
        }
        case AidTextFieldCellStylePhone: {
            self.valueTextField.placeholder = @"请输入手机号码";
            self.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case AidTextFieldCellStyleEmail: {
            self.valueTextField.placeholder = @"请输入邮箱地址";
            self.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        }
        case AidTextFieldCellStylePassword: {
            self.valueTextField.placeholder = @"请输入密码";
            self.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.valueTextField.keyboardType = UIKeyboardTypeASCIICapable;
            self.valueTextField.secureTextEntry = YES;
            break;
        }
        case AidTextFieldCellStyleURL: {
            self.valueTextField.placeholder = @"请输入链接地址";
            self.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.valueTextField.keyboardType = UIKeyboardTypeURL;
            break;
        }
        case AidTextFieldCellStyleSelect: {
            self.valueTextField.textAlignment = NSTextAlignmentRight;
            self.valueTextField.placeholder = @"请点击进行选择";
            self.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            self.valueTextField.keyboardType = UIKeyboardTypeDefault;
            self.valueTextField.enabled = NO;
            self.moreImageView.hidden = NO;
            break;
        }
        case AidTextFieldCellStyleNoEnable: {
            self.valueTextField.placeholder = @"请点击进行选择";
            self.valueTextField.clearButtonMode = UITextFieldViewModeAlways;
            self.valueTextField.keyboardType = UIKeyboardTypeDefault;
//            self.valueTextField.enabled = NO;
            break;
        }
    }
}

- (void)setLineStyle:(AidSepratorStyle)lineStyle
{
    _lineStyle = lineStyle;
    
    for (int i = 0; i < 3; i++) {
        NSInteger style = (1 << i);
        switch (style & lineStyle) {
            case AidSepratorStyleNone: {
                self.topLineView.hidden = YES;
                self.bottomLineView.hidden = YES;
                break;
            }
            case AidSepratorStyleTop: {
                self.topLineView.hidden = NO;
                break;
            }
            case AidSepratorStyleBottom: {
                self.bottomLineView.hidden = NO;
                break;
            }
        }
    }
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    
    self.titleLabel.text = titleText;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.valueTextField.placeholder = placeholder;
}

- (NSString *)valueText
{
    return self.valueTextField.text;
}

- (void)setValueText:(NSString *)valueText
{
    _valueText = valueText;
    
    self.valueTextField.text = valueText;
}

@end
