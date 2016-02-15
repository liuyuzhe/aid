//
//  AidDatePickerView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/7.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AidValueChanged)(NSDate *currentDate);

@interface AidDatePickerView : UIView

@property (nonatomic, copy) AidValueChanged valueChanged;
@property (nonatomic, copy) AidValueChanged doneItemTouched;

@property (nonatomic, assign) UIDatePickerMode mode;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, assign) NSInteger minuteInterval;

@end
