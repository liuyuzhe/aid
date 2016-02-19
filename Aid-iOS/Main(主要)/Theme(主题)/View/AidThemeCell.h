//
//  AidThemeCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AidThemeRecord;

@interface AidThemeCell : UITableViewCell

@property (nonatomic, strong) AidThemeRecord *themeRecord;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
