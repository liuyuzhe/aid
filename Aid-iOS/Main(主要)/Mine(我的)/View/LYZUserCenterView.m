//
//  LYZUserCenterView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/28.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZUserCenterView.h"

#import "Masonry.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;

@interface LYZUserCenterView ()

@property (nonatomic, strong) UIView *bgView; /**< 背景视图 */
@property (nonatomic, strong) UIView *avartarView; /**< 头像视图 */
@property (nonatomic, strong) UIImageView *avartarBgImageView; /**< 头像背景视图 */
@property (nonatomic, strong) UIImageView *avartarImageView; /**< 头像视图 */
@property (nonatomic, strong) UIButton *loginButton; /**< 登陆按钮 */
@property (nonatomic, strong) UILabel *nameLabel; /**< 用户名标签 */
@property (nonatomic, strong) UIImageView *indicatorImageView; /**< 指示器视图 */

@end


@implementation LYZUserCenterView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPageSubviews];

        [self addSubview:_bgView];
        [_bgView addSubview:_avartarView];
        [_avartarView addSubview:_avartarBgImageView];
        [_avartarView addSubview:_avartarImageView];
        [_bgView addSubview:_loginButton];
        [_bgView addSubview:_indicatorImageView];
        [_bgView addSubview:_nameLabel];
        
        [self layoutPageSubviews];
    }
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
    _bgView = [[UIView alloc] init];
//    _bgView.backgroundColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    [_bgView tappedGesture:^{
        [weakSelf backgroundViewTapped];
    }];
    
    _avartarView = [[UIView alloc] init];
    
    _avartarBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_avartar_bg"]];
    
    _avartarImageView = [[UIImageView alloc] init];
    _avartarImageView.layer.cornerRadius = _avartarImageView.width / 2 ;
    _avartarImageView.layer.borderWidth = 5;
    _avartarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avartarImageView.layer.masksToBounds = YES;

    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"userCenter_login_bg"] stretchImageWithEdge:2] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"userCenter_login_bg_hl"] stretchImageWithEdge:2] forState:UIControlStateHighlighted];
    [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
   
    _indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_header_arrow"]];
 
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [_avartarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).mas_offset(AidNavigationHeadHeight);
        make.centerX.equalTo(_bgView);
        make.height.mas_equalTo(80);
    }];
    
    [_avartarBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_avartarView);
    }];
    
    [_avartarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_avartarView).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(_avartarView.mas_bottom).mas_offset(AidViewDefaultOffset);
        make.height.mas_equalTo(AidToolBarHeight);
    }];
    
    [_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView).mas_offset(-AidViewDefaultOffset);
        make.width.mas_equalTo(9);
        make.centerY.equalTo(_avartarView);
        make.height.mas_equalTo(17);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView);
        make.top.mas_equalTo(_avartarView.mas_bottom).mas_offset(AidViewDefaultOffset);
    }];
}

#pragma mark - override super

#pragma mark - event response

- (void)loginButtonAction
{
    if ([self.delegate respondsToSelector:@selector(didClickToLogin)]) {
        [self.delegate didClickToLogin];
    }
}

- (void)backgroundViewTapped
{
    if (self.state == LYZHeaderViewStateLogin && [self.delegate respondsToSelector:@selector(didClickToEnterUserCenter)]) {
        [self.delegate didClickToEnterUserCenter];
    }
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setState:(LYZHeaderViewState)state
{
    _state = state;
    
    if (state == LYZHeaderViewStateNone) {
        self.avartarBgImageView.hidden = NO;
//        self.avartarImageView.image = nil;
        self.avartarImageView.hidden = YES;
        self.loginButton.hidden = NO;
        self.indicatorImageView.hidden = YES;
        self.nameLabel.hidden = YES;
    }
    else {
        self.avartarBgImageView.hidden = YES;
        self.avartarImageView.hidden = NO;
        self.loginButton.hidden = YES;
        self.indicatorImageView.hidden = NO;
        self.nameLabel.hidden = NO;
    }
}

@end
