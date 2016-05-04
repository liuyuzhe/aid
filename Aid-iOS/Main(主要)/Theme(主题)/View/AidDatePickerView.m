//
//  AidDatePickerView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/7.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDatePickerView.h"

@interface AidDatePickerView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;

@end


@implementation AidDatePickerView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
        
        [self addSubview:_datePicker];
        [self addSubview:_toolbar];
        
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
    _datePicker = [[UIDatePicker alloc] init];
//    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]; // 区域
//    _datePicker.calendar = [NSCalendar currentCalendar]; // 历法
//    _datePicker.timeZone = [NSTimeZone defaultTimeZone]; // 时区
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar * toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault; // 风格
    toolbar.translucent = YES; // 半透明
    [toolbar sizeToFit];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelItemAction:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneItemAction:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[cancelItem, spaceItem, doneItem];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
}

#pragma mark - override super

#pragma mark - event response

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.valueChanged) {
        self.valueChanged(sender.date);
    }
}

- (void)cancelItemAction:(UIBarButtonItem *)item
{
    [self removeFromSuperview];
}

- (void)doneItemAction:(UIBarButtonItem *)item
{
    if (self.doneItemTouched) {
        self.doneItemTouched(self.datePicker.date);
    }
    
    [self removeFromSuperview];
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setMode:(UIDatePickerMode)mode
{
    _mode = mode;
    
    self.datePicker.datePickerMode = mode;
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

@end
