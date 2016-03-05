//
//  AidWeekDayCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/5.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidWeekDayCell.h"

#import "Masonry.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;
static const CGFloat AidWeekdayViewInset = 10;

@interface AidWeekDayCell ()

@property (nonatomic, strong) UIView *topView; /**< 上半部分视图 */
@property (nonatomic, strong) UIView *lineView; /**< 分割线视图 */
@property (nonatomic, strong) UIView *bottomView; /**< 下半部分视图 */

@property (nonatomic, strong) UILabel *titleLabel; /**< 标题标签 */
@property (nonatomic, strong) UIButton *workdayButton; /**< 工作日按钮 */
@property (nonatomic, strong) UIButton *weekendButton; /**< 周末按钮 */
@property (nonatomic, strong) UIButton *everydayButton; /**< 每天按钮 */

@property (nonatomic, strong) NSArray<NSString *> *titleNames; /**< 星期名称数组 */
@property (nonatomic, strong) NSMutableArray<__kindof UIButton *> *buttonArray; /**< 星期按钮数组 */
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *lineArray; /**< 星期分割线数组 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *stateDictionary; /**< 星期状态字典 */

@end


@implementation AidWeekDayCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidWeekDayCell class]);
    AidWeekDayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidWeekDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleNames = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        _buttonArray = [NSMutableArray arrayWithCapacity:_titleNames.count];
        _lineArray = [NSMutableArray arrayWithCapacity:_titleNames.count - 1];
        _stateDictionary = [NSMutableDictionary dictionaryWithCapacity:_titleNames.count];
        
        [self setupPageSubviews];
        
        [self.contentView addSubview:_topView];
        [self.contentView addSubview:_lineView];
        [self.contentView addSubview:_bottomView];
        [_topView addSubview:_titleLabel];
        [_topView addSubview:_workdayButton];
        [_topView addSubview:_weekendButton];
        [_topView addSubview:_everydayButton];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    // 上半部分视图
    _topView = [[UIView alloc] init];

    // 分割线视图
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor blackColor];
    
    // 下半部分视图
    _bottomView = [[UIView alloc] init];

    // 标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"周期：";
    
    // 工作日按钮
    _workdayButton = [[UIButton alloc] init];
    _workdayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _workdayButton.tag = 50;
    [_workdayButton setTitle:@"工作日" forState:UIControlStateNormal];
    [_workdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_workdayButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_workdayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 周末按钮
    _weekendButton = [[UIButton alloc] init];
    _weekendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _weekendButton.tag = 51;
    [_weekendButton setTitle:@"周末" forState:UIControlStateNormal];
    [_weekendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_weekendButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_weekendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 每天按钮
    _everydayButton = [[UIButton alloc] init];
    _everydayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _everydayButton.tag = 52;
    [_everydayButton setTitle:@"每天" forState:UIControlStateNormal];
    [_everydayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_everydayButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_everydayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 星期按钮数组
    for (int i = 0; i < _titleNames.count; i++) {
        UIButton *dayButton = [[UIButton alloc] init];
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
    
    // 星期分割线数组
    for (int i = 0; i < _titleNames.count - 1; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
#warning lineView布局问题
//        [_bottomView addSubview:lineView];
        
        [_lineArray addObject:lineView];
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.bottom.equalTo(_lineView.mas_top);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(AidViewDefaultOffset);
        make.height.mas_equalTo(0.5);
        make.center.equalTo(weakSelf);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(_lineView.mas_bottom);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView).offset(AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_workdayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_weekendButton.mas_left).offset(-AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_weekendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_everydayButton.mas_left).offset(-AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_everydayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView).offset(-AidViewDefaultOffset);
        make.centerY.equalTo(_topView);
    }];
    
    [_buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                              withFixedSpacing:0.5
                                   leadSpacing:AidWeekdayViewInset
                                   tailSpacing:AidWeekdayViewInset];
    [_buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_bottomView);
    }];
    
//    [_lineArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:0.5 leadSpacing:AidWeekdayViewInset tailSpacing:AidWeekdayViewInset];
//    [_lineArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomView).mas_offset(AidViewDefaultInset);
//        make.bottom.equalTo(_bottomView).mas_offset(-AidViewDefaultInset);
//    }];
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//    [super setEditing:editing animated:animated];
}

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
