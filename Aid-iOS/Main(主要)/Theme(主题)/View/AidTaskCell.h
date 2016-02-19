//
//  AidTaskCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AidTaskRecord;

@interface AidTaskCell : UITableViewCell

@property (nonatomic, strong) AidTaskRecord *taskRecord;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
