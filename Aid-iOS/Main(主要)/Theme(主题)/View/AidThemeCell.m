//
//  AidThemeCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidThemeCell.h"

#import "AidThemeRecord.h"

@interface AidThemeCell ()

@property (nonatomic, strong) UIImageView *themeImageView; /**< 主题图片 */
@property (nonatomic, strong) UILabel *themeNameLabel; /**< 主题名称 */
@property (nonatomic, strong) UILabel *themeDescribeLabel; /**< 主题描述 */
@property (nonatomic, strong) UILabel *praiseLabel; /**< 是否点赞 */

@end


@implementation AidThemeCell

#pragma mark - life cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidThemeCell class]);
    AidThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImage *bgImage = [UIImage imageNamed:@"ItemBackground"];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
        cell.backgroundView = bgView;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_themeImageView];
        [self.contentView addSubview:_themeNameLabel];
        [self.contentView addSubview:_themeDescribeLabel];
        [self.contentView addSubview:_praiseLabel];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _themeImageView = [[UIImageView alloc] init];
    _themeNameLabel = [[UILabel alloc] init];
    _themeDescribeLabel = [[UILabel alloc] init];
    _praiseLabel = [[UILabel alloc] init];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(@80);
        make.left.equalTo(weakSelf.mas_left).with.offset(2);
        make.width.mas_equalTo(@80);
    }];
    
    [_themeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(2);
        make.height.mas_equalTo(@30);
        make.left.equalTo(_themeImageView.mas_right).with.offset(2);
    }];
    
    [_themeDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_themeNameLabel.mas_top).with.offset(2);
        make.bottom.equalTo(_praiseLabel.mas_bottom).with.offset(2);
        make.left.equalTo(_themeImageView.mas_right).with.offset(2);
    }];
    
    [_praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(2);
        make.height.mas_equalTo(@30);
        make.left.equalTo(_themeImageView.mas_right).with.offset(2);
    }];
}

#pragma mark - override super

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

#pragma mark - getters and setters

- (void)setThemeRecord:(AidThemeRecord *)themeRecord
{
    _themeRecord = themeRecord;
    
    self.themeImageView.image = [UIImage imageNamed:themeRecord.imageName];
    self.themeNameLabel.text = themeRecord.name;
    self.themeDescribeLabel.text = themeRecord.describe;
}

@end
