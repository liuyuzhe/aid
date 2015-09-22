//
//  UITableView+LYZExtension.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/25.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LYZExtension)

/**
 *
 !!!:
 当tableview的dataSource为空，即没有数据可显示时，该方法无效。
 
 解决办法：
 在numberOfRowsInsection函数中，通过判断dataSouce的数据个数。
 若为零将tableview的separatorStyle设置为UITableViewCellSeparatorStyleNone去掉分割线，
 若大于零将其设置为UITableViewCellSeparatorStyleSingleLine即可。
 
 */
- (void)hideExtraCellLine;

@end
