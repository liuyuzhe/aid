//
//  LYZSwipeTableCell.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/6.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZSwipeTableCell.h"
#import "Masonry.h"

@interface LYZSwipeTableCell ()

@end


@implementation LYZSwipeTableCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _subject = [[UILabel alloc] init];
        _finishFlag = [[UIView alloc] init];

        [self.contentView addSubview:_subject];
        [self.contentView addSubview:_finishFlag];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)layoutPageSubviews
{
    __weak LYZSwipeTableCell *weakSelf = self;
    
    static const int padding = 10;
    
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(self.finishFlag.mas_right).with.offset(padding);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-padding);
    }];
    
    [self.finishFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

@end
