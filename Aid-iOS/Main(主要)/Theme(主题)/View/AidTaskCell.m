//
//  AidTaskCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidTaskCell.h"

#import "AidTaskRecord.h"

@interface AidTaskCell ()

@property (nonatomic, strong) UIImageView *taskImageView; /**< 任务图片 */
@property (nonatomic, strong) UILabel *taskNameLabel; /**< 任务名称 */
@property (nonatomic, strong) UILabel *completeTimeLabel; /**< 完成时间 */
@property (nonatomic, strong) UIImageView *completeImageView; /**< 是否完成 */
@property (nonatomic, strong) UIImageView *alarmImageView; /**< 是否提醒 */
@property (nonatomic, strong) UIImageView *repeatImageView; /**< 是否重复 */
@property (nonatomic, strong) UIImageView *priorityImageView; /**< 优先级 */

@end

@implementation AidTaskCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidTaskCell class]);
    AidTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImage *bgImage = [UIImage imageNamed:@"ItemBackground"];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
        cell.backgroundView = bgView;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_taskImageView];
        [self.contentView addSubview:_taskNameLabel];
        [self.contentView addSubview:_completeTimeLabel];
        [self.contentView addSubview:_completeImageView];
        [self.contentView addSubview:_alarmImageView];
        [self.contentView addSubview:_repeatImageView];
        [self.contentView addSubview:_priorityImageView];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _taskImageView = [[UIImageView alloc] init];
    _taskNameLabel = [[UILabel alloc] init];
    _completeTimeLabel = [[UILabel alloc] init];
    _completeImageView = [[UIImageView alloc] init];
    _alarmImageView = [[UIImageView alloc] init];
    _repeatImageView = [[UIImageView alloc] init];
    _priorityImageView = [[UIImageView alloc] init];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(@80);
        make.left.equalTo(weakSelf.mas_left).with.offset(2);
        make.width.mas_equalTo(@80);
    }];
    
    [_taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(2);
        make.height.mas_equalTo(@30);
        make.left.equalTo(_taskImageView.mas_right).with.offset(2);
    }];
    
    [_completeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskNameLabel.mas_top).with.offset(2);
        make.bottom.equalTo(_completeImageView.mas_bottom).with.offset(2);
        make.left.equalTo(_taskImageView.mas_right).with.offset(2);
    }];
    
    [_completeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(2);
        make.height.mas_equalTo(@30);
        make.left.equalTo(_taskImageView.mas_right).with.offset(2);
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

- (void)setTaskRecord:(AidTaskRecord *)taskRecord
{
    _taskRecord = taskRecord;
    
    self.taskNameLabel.text = taskRecord.name;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:taskRecord.completeTime.doubleValue];
#warning format开销
    self.completeTimeLabel.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
