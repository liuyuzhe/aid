//
//  AidAgendaTaskCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidAgendaTaskCell.h"

@implementation AidAgendaTaskCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidAgendaTaskCell class]);
    AidAgendaTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidAgendaTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"今日任务";
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
