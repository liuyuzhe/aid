//
//  AidThemeCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidThemeCell.h"

#import "AidThemeRecord.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;

@interface AidThemeCell ()

@property (nonatomic, strong) UIImageView *themeImageView; /**< 主题图片 */
@property (nonatomic, strong) UILabel *themeNameLabel; /**< 主题名称 */
@property (nonatomic, strong) UILabel *themeDescribeLabel; /**< 主题描述 */

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
//        cell.backgroundView = bgView;
//        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupPageSubviews];
        
        [self.contentView addSubview:_themeImageView];
        [self.contentView addSubview:_themeNameLabel];
        [self.contentView addSubview:_themeDescribeLabel];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _themeImageView = [[UIImageView alloc] init];
    
    _themeNameLabel = [[UILabel alloc] init];
    _themeNameLabel.font = [UIFont systemFontOfSize:20];
    _themeNameLabel.textColor = [UIColor blueColor];
    _themeNameLabel.textAlignment = NSTextAlignmentCenter;

    _themeDescribeLabel = [[UILabel alloc] init];
    _themeNameLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
    
    [_themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [_themeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [_themeDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(AidViewDefaultOffset);
        make.right.equalTo(weakSelf).offset(-AidViewDefaultOffset);
        make.bottom.equalTo(weakSelf);
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
