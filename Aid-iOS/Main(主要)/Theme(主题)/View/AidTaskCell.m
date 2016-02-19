//
//  AidTaskCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidTaskCell.h"

#import "AidTaskRecord.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;

@interface AidTaskCell ()

@property (nonatomic, strong) UILabel *taskNameLabel; /**< 任务名称 */
@property (nonatomic, strong) UILabel *taskTimeLabel; /**< 任务起止时间 */
@property (nonatomic, strong) UIImageView *alarmImageView; /**< 提醒视图 */
@property (nonatomic, strong) UILabel *repeatLabel; /**< 重复周期 */

@property (nonatomic, strong) NSDateFormatter *formatter; /**< 日期格式化，添加为属性是为了优化性能 */

@end


@implementation AidTaskCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidTaskCell class]);
    AidTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        UIImage *bgImage = [UIImage imageNamed:@"ItemBackground"];
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
//        cell.backgroundView = bgView;
//        cell.backgroundColor = [UIColor clearColor];
//        UIView *view_bg = [[UIView alloc] initWithFrame:cell.frame];
//        view_bg.backgroundColor = [UIColor clearColor];
//        cell.selectedBackgroundView = view_bg;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_taskNameLabel];
        [self.contentView addSubview:_taskTimeLabel];
        [self.contentView addSubview:_alarmImageView];
        [self.contentView addSubview:_repeatLabel];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _taskNameLabel = [[UILabel alloc] init];
    _taskNameLabel.font = [UIFont systemFontOfSize:20];
    _taskNameLabel.textColor = [UIColor blueColor];
    _taskNameLabel.textAlignment = NSTextAlignmentLeft;

    _taskTimeLabel = [[UILabel alloc] init];
    _taskTimeLabel.font = [UIFont systemFontOfSize:16];

    _alarmImageView = [[UIImageView alloc] init];
    
    _repeatLabel = [[UILabel alloc] init];
    _repeatLabel.font = [UIFont systemFontOfSize:16];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
    
    [_taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_taskTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.top.equalTo(weakSelf).mas_offset(AidViewDefaultInset);
    }];
    
    [_alarmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-AidViewDefaultOffset);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.bottom.equalTo(weakSelf).mas_offset(-AidViewDefaultInset);
    }];
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

#pragma mark - getters and setters

- (NSDateFormatter *)formatter
{
    if (! _formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd EEE";
        _formatter.locale = [NSLocale currentLocale];
    }
    return _formatter;
}

- (void)setTaskRecord:(AidTaskRecord *)taskRecord
{
    _taskRecord = taskRecord;
    
    self.taskNameLabel.text = taskRecord.name;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:taskRecord.startTime.doubleValue];
    NSString *startString = [self.formatter stringFromDate:startDate];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:taskRecord.endTime.doubleValue];
    NSString *endString = [self.formatter stringFromDate:endDate];
    self.taskTimeLabel.text = [NSString stringWithFormat:@"%@ —— %@", startString, endString];
    
    self.repeatLabel.text = taskRecord.repeat;
}

@end
