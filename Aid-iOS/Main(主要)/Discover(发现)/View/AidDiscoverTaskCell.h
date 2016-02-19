//
//  AidDiscoverTaskCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AidDiscoverTaskRecord;

@interface AidDiscoverTaskCell : UITableViewCell

@property (nonatomic, strong) AidDiscoverTaskRecord *discoverTaskRecord;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
