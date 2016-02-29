//
//  AidSettingCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/28.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidSettingCell.h"

@implementation AidSettingCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidSettingCell class]);
    AidSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//        UIImage *bgImage = [UIImage imageNamed:@"ItemBackground"];
//        UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
//        cell.backgroundView = bgView;
//        UIView *view_bg = [[UIView alloc] initWithFrame:cell.frame];
//        view_bg.backgroundColor = [UIColor clearColor];
//        cell.selectedBackgroundView = view_bg;
//        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

@end
