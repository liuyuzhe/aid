//
//  AidWeekDayView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/6.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidWeekDayView.h"

#import "Masonry.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;
static const CGFloat AidWeekdayViewInset = 10;

@interface AidWeekDayView ()

@property (nonatomic, strong) UIView *topView; /**< 上半部分视图 */
@property (nonatomic, strong) UIView *lineView; /**< 分割线视图 */
@property (nonatomic, strong) UIView *bottomView; /**< 下半部分视图 */

@property (nonatomic, strong) UILabel *titleLabel; /**< 标题标签 */
@property (nonatomic, strong) UIButton *workdayButton; /**< 工作日按钮 */
@property (nonatomic, strong) UIButton *weekendButton; /**< 周末按钮 */
@property (nonatomic, strong) UIButton *everydayButton; /**< 每天按钮 */

@property (nonatomic, strong) NSArray<NSString *> *titleNames; /**< 星期名称数组 */
@property (nonatomic, strong) NSMutableArray<__kindof UIButton *> *buttonArray; /**< 星期按钮数组 */

@end


@implementation AidWeekDayView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleNames = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        _buttonArray = [NSMutableArray arrayWithCapacity:_titleNames.count];
        _stateDictionary = [NSMutableDictionary dictionaryWithCapacity:_titleNames.count];

        [self setupPageSubviews];
        
        [self addSubview:_topView];
        [self addSubview:_lineView];
        [self addSubview:_bottomView];
        [_topView addSubview:_titleLabel];
        [_topView addSubview:_workdayButton];
        [_topView addSubview:_weekendButton];
        [_topView addSubview:_everydayButton];
        
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
    // 上半部分视图
    _topView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 分割线视图
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor blackColor];
    
    // 下半部分视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 标题标签
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"周期：";
    
    // 工作日按钮
    _workdayButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _workdayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _workdayButton.tag = 50;
    [_workdayButton setTitle:@"工作日" forState:UIControlStateNormal];
    [_workdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_workdayButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_workdayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 周末按钮
    _weekendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _weekendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _weekendButton.tag = 51;
    [_weekendButton setTitle:@"周末" forState:UIControlStateNormal];
    [_weekendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_weekendButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_weekendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 每天按钮
    _everydayButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _everydayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _everydayButton.tag = 52;
    [_everydayButton setTitle:@"每天" forState:UIControlStateNormal];
    [_everydayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_everydayButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_everydayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 星期按钮数组
    for (int i = 0; i < _titleNames.count; i++) {
        UIButton *dayButton = [[UIButton alloc] initWithFrame:CGRectZero];
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14];
        dayButton.tag = 100 + i;
        
        [dayButton setTitle:_titleNames[i] forState:UIControlStateNormal];
        [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dayButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [dayButton addTarget:self action:@selector(dayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:dayButton];
        
        [_buttonArray addObject:dayButton];
        [_stateDictionary setObject:@(dayButton.selected) forKey:_titleNames[i]];
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.bottom.equalTo(_lineView.mas_top);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.height.mas_equalTo(0.5);
        make.center.equalTo(weakSelf);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(_lineView.mas_bottom);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView).mas_offset(AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_workdayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_weekendButton.mas_left).mas_offset(-AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_weekendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_everydayButton.mas_left).mas_offset(-AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_everydayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView).mas_offset(-AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                              withFixedSpacing:0.5
                                   leadSpacing:AidWeekdayViewInset
                                   tailSpacing:AidWeekdayViewInset];
    [_buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
    }];
}

#pragma mark - override super

#pragma mark - event response

- (void)buttonAction:(UIButton *)button
{
    button.selected = ! button.selected;
    
    NSInteger index = button.tag;
    if (index == 50) {
        self.weekendButton.selected = NO;
        self.everydayButton.selected = NO;
    }
    else if (index == 51) {
        self.workdayButton.selected = NO;
        self.everydayButton.selected = NO;
    }
    else if (index == 52) {
        self.workdayButton.selected = NO;
        self.weekendButton.selected = NO;
    }
    
    [self updateDayButtons];
    [self weekDayAction];
}

- (void)dayButtonAction:(UIButton *)button
{
    button.selected = ! button.selected;
    
    [self updateButtons];
    [self weekDayAction];
}

#pragma mark - notification response

#pragma mark - private methods

-(void)updateDayButtons
{
    if (self.workdayButton.selected) {
        self.buttonArray[0].selected = NO;
        for (int i = 1; i < 6; i++) {
            self.buttonArray[i].selected = YES;
        }
        self.buttonArray[6].selected = NO;
    }
    else if (self.weekendButton.selected) {
        self.buttonArray[0].selected = YES;
        for (int i = 1; i < 6; i++) {
            self.buttonArray[i].selected = NO;
        }
        self.buttonArray[6].selected = YES;
    }
    else if (self.everydayButton.selected) {
        for (UIButton *button in self.buttonArray) {
            button.selected = YES;
        }
    }
    else {
        for (UIButton *button in self.buttonArray) {
            button.selected = NO;
        }
    }
}

-(void)updateButtons
{
    BOOL state1 = YES;
    BOOL state2 = NO;
    BOOL state3 = YES;
    
    for (UIButton *button in self.buttonArray) {
        state1 &= button.selected;
    }
    
    if (state1) {
        self.workdayButton.selected = NO;
        self.weekendButton.selected = NO;
        self.everydayButton.selected = YES;
    }
    else if (self.buttonArray[0].selected && self.buttonArray[6].selected) {
        for (int i = 1; i < 6; i++) {
            state2 |= self.buttonArray[i].selected;
        }
        if (! state2) {
            self.workdayButton.selected = NO;
            self.weekendButton.selected = YES;
            self.everydayButton.selected = NO;
        }
        else {
            self.workdayButton.selected = NO;
            self.weekendButton.selected = NO;
            self.everydayButton.selected = NO;
        }
    }
    else if (! self.buttonArray[0].selected && ! self.buttonArray[6].selected) {
        for (int i = 1; i < 6; i++) {
            state3 &= self.buttonArray[i].selected;
        }
        if (state3) {
            self.workdayButton.selected = YES;
            self.weekendButton.selected = NO;
            self.everydayButton.selected = NO;
        }
        else {
            self.workdayButton.selected = NO;
            self.weekendButton.selected = NO;
            self.everydayButton.selected = NO;
        }
    }
    else {
        self.workdayButton.selected = NO;
        self.weekendButton.selected = NO;
        self.everydayButton.selected = NO;
    }
}

- (void)weekDayAction
{
    for (int i = 0; i < self.buttonArray.count; i++) {
        [self.stateDictionary setObject:@(self.buttonArray[i].selected) forKey:self.titleNames[i]];
    }
    
    if (self.weekDayTouched) {
        self.weekDayTouched([self.stateDictionary copy]);
    }
}

#pragma mark - getters and setters

@end
