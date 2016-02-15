//
//  AidWeekDayCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/5.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^weekDayAction)(NSDictionary *dictionary);

@interface AidWeekDayCell : UITableViewCell

@property (nonatomic, copy) weekDayAction weekDayTouched;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
