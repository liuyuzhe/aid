//
//  AidHotDetailCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/30.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidHotDetailCell.h"

@implementation AidHotDetailCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidHotDetailCell class]);
    AidHotDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidHotDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"热门任务";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
