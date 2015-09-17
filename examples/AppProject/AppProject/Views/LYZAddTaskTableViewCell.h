//
//  LYZAddTaskTableViewCell.h
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYZAddTaskTableViewCellDelegate <NSObject>

@required
- (void)addButtonTouched:(UIButton *)button;

@end



@interface LYZAddTaskTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LYZAddTaskTableViewCellDelegate> delegate;

@property (nonatomic, strong, readonly) UIButton *addButton;

@end

