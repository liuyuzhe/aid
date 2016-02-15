//
//  AidDatePickerCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/6.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AidDatePickerCellStyle) {
    AidDatePickerCellStyleTime = 1,
    AidDatePickerCellStyleDate,
    AidDatePickerCellStyleDateTime,
    AidDatePickerCellStyleCountDownTimer,
};

@interface AidDatePickerCell : UITableViewCell

@property (nonatomic, assign) AidDatePickerCellStyle cellStyle;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, assign) NSInteger minuteInterval;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *valueText;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
