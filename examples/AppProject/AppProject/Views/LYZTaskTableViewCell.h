//
//  LYZTaskTableViewCell.h
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYZTaskTableViewCellDelegate <NSObject>

@required
- (void)starButtonTouched:(UIButton *)button;
- (void)completeButtonTouched:(UIButton *)button;

@end



@interface LYZTaskTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LYZTaskTableViewCellDelegate> delegate;

@property (nonatomic, strong) UILabel *title;

@end
