//
//  UITableView+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/25.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "UITableView+LYZExtension.h"

@implementation UITableView (LYZExtension)

- (void)hideExtraCellLine
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

@end
