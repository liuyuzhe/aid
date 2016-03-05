//
//  AidDiscoverTaskCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverTaskCell.h"

#import "Masonry.h"

#import "AidDiscoverTaskRecord.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;

@interface AidDiscoverTaskCell ()

@property (nonatomic, strong) UIView *bgContentView; /**< 背景内容视图 */
//@property (nonatomic, strong) UIImageView *taskImageView; /**< 任务图片 */
@property (nonatomic, strong) UILabel *taskNameLabel; /**< 任务名称 */
@property (nonatomic, strong) UILabel *taskTimeLabel; /**< 任务起止时间 */
@property (nonatomic, strong) UIImageView *alarmImageView; /**< 提醒视图 */
@property (nonatomic, strong) UILabel *repeatLabel; /**< 重复周期 */

@property (nonatomic, strong) NSDateFormatter *formatter; /**< 日期格式化，添加为属性是为了优化性能 */

@end


@implementation AidDiscoverTaskCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidDiscoverTaskCell class]);
    AidDiscoverTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidDiscoverTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        UIImage *bgImage = [UIImage imageNamed:@"ItemBackground"];
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
//        cell.backgroundView = bgView;
//        UIView *view_bg = [[UIView alloc] initWithFrame:cell.frame];
//        view_bg.backgroundColor = [UIColor clearColor];
//        cell.selectedBackgroundView = view_bg;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_bgContentView];
        [_bgContentView addSubview:_taskNameLabel];
        [_bgContentView addSubview:_taskTimeLabel];
        [_bgContentView addSubview:_alarmImageView];
        [_bgContentView addSubview:_repeatLabel];

        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _bgContentView = [[UIView alloc] init];
    _bgContentView.backgroundColor = [UIColor whiteColor];
    _bgContentView.layer.cornerRadius = 5;
    _bgContentView.layer.masksToBounds = YES;
    
    _taskNameLabel = [[UILabel alloc] init];
    _taskNameLabel.font = AidBigFont;
    _taskNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _taskTimeLabel = [[UILabel alloc] init];
    _taskTimeLabel.font = AidNormalFont;
    _taskTimeLabel.textColor = [UIColor blueColor];
    _taskTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    _alarmImageView = [[UIImageView alloc] init];
    
    _repeatLabel = [[UILabel alloc] init];
    _repeatLabel.font = AidNormalFont;
    _repeatLabel.textColor = [UIColor lightGrayColor];
    _repeatLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
    
    [_bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 5, 5, 5));
    }];
    
    [_taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgContentView).mas_offset(AidViewDefaultInset);
        make.centerY.equalTo(_bgContentView);
    }];
    
    [_taskTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgContentView).mas_offset(AidViewDefaultInset);
        make.top.equalTo(_bgContentView);
    }];
    
    [_alarmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgContentView).mas_offset(-AidViewDefaultInset);
        make.centerY.equalTo(_bgContentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgContentView).mas_offset(AidViewDefaultInset);
        make.bottom.equalTo(_bgContentView);
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

- (void)setDiscoverTaskRecord:(AidDiscoverTaskRecord *)discoverTaskRecord
{
    _discoverTaskRecord = discoverTaskRecord;
    
    self.taskNameLabel.text = discoverTaskRecord.name;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:discoverTaskRecord.startTime.doubleValue];
    NSString *startString = [startDate friendlyDateString];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:discoverTaskRecord.endTime.doubleValue];
    NSString *endString = [endDate friendlyDateString];
    self.taskTimeLabel.text = [NSString stringWithFormat:@"%@ — %@", startString, endString];
    
    self.repeatLabel.text = [NSString stringWithFormat:@"周期：%@", discoverTaskRecord.repeat];
}

@end
