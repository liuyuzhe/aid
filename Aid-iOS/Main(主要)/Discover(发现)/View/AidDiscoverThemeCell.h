//
//  AidDiscoverThemeCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AidDiscoverThemeRecord;

@interface AidDiscoverThemeCell : UITableViewCell

@property (nonatomic, strong) AidDiscoverThemeRecord *discoverThemeRecord;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
