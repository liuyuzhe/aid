//
//  AidDatePickerCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/6.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDatePickerCell.h"

@interface AidDatePickerCell ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end


@implementation AidDatePickerCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidDatePickerCell class]);
    AidDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidDatePickerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
//        cell.backgroundColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_datePicker];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - public method

-(void)highlight
{
    self.detailTextLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    self.detailTextLabel.textColor = [UIColor blackColor];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _datePicker = [[UIDatePicker alloc] init];
//    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]; // 区域
//    _datePicker.calendar = [NSCalendar currentCalendar]; // 历法
//    _datePicker.timeZone = [NSTimeZone defaultTimeZone]; // 时区
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
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

#pragma mark - event response

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.valueText = [self formatterDate:sender.date];
}

#pragma mark - notification response

#pragma mark - private methods

- (NSString *)formatterDate:(NSDate *)date
{
    NSString *formatterDate;
    
    switch (self.cellStyle) {
        case AidDatePickerCellStyleTime: {
            formatterDate = [date stringWithFormat:@"HH:mm:ss"];
            break;
        }
        case AidDatePickerCellStyleDate: {
            formatterDate = [date stringWithFormat:@"yyyy-MM-dd EEE"];
            break;
        }
        case AidDatePickerCellStyleDateTime: {
            formatterDate = [date stringWithFormat:@"yyyy-MM-dd EEE HH:mm"];
            break;
        }
        case AidDatePickerCellStyleCountDownTimer: {
            formatterDate = [date stringWithFormat:@"HH:mm"];
            break;
        }
            
        default:
            break;
    }
    
    return formatterDate;
}

#pragma mark - getters and setters

- (void)setCellStyle:(AidDatePickerCellStyle)cellStyle
{
    _cellStyle = cellStyle;
    
    switch (cellStyle) {
        case AidDatePickerCellStyleTime: {
            self.textLabel.text = @"时间";
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        }
        case AidDatePickerCellStyleDate: {
            self.textLabel.text = @"日期";
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        }
        case AidDatePickerCellStyleDateTime: {
            self.textLabel.text = @"日期和时间";
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        }
        case AidDatePickerCellStyleCountDownTimer: {
            self.textLabel.text = @"倒计时";
            self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
            break;
        }
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    self.datePicker.date = currentDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    
    self.datePicker.maximumDate = maximumDate;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval
{
    _minuteInterval = minuteInterval;
    
    self.datePicker.minuteInterval = minuteInterval;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    
    self.textLabel.text = titleText;
}

- (void)setValueText:(NSString *)valueText
{
    _valueText = valueText;
    
    self.detailTextLabel.text = valueText;
}

@end
