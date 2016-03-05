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

@property (nonatomic, strong) UIView *bgContentView; /**< 背景内容视图 */
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
        
        [self.contentView addSubview:_bgContentView];
        [_bgContentView addSubview:_themeImageView];
        [_bgContentView addSubview:_themeNameLabel];
        [_bgContentView addSubview:_themeDescribeLabel];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _bgContentView = [[UIView alloc] init];
    
    _themeImageView = [[UIImageView alloc] init];
    
    _themeNameLabel = [[UILabel alloc] init];
    _themeNameLabel.font = AidBigBoldFont;
    _themeNameLabel.textColor = [UIColor whiteColor];
    _themeNameLabel.textAlignment = NSTextAlignmentCenter;

    _themeDescribeLabel = [[UILabel alloc] init];
    _themeDescribeLabel.font = AidNormalFont;
    _themeDescribeLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.contentView;
    
    [_bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 5, 5, 5));
    }];

    [_themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgContentView);
    }];
    
    [_themeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgContentView);
    }];
    
    [_themeDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgContentView).offset(AidViewDefaultInset);
        make.right.equalTo(_bgContentView).offset(-AidViewDefaultInset);
        make.bottom.equalTo(_bgContentView);
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
//    
//    static NSString * const AidThemeImageTableName = @"themeImageTable";
//    YTKKeyValueStore  *themeImageStore = [[YTKKeyValueStore alloc] initDBWithName:@"themeImage.db"];
//    
//    NSData *queryUser = [themeImageStore getObjectById:themeRecord.imageName fromTable:AidThemeImageTableName];
//    self.themeImageView.image = [UIImage imageWithData:queryUser];
//    
    self.themeImageView.image = [UIImage imageNamed:themeRecord.imageName];
    self.themeNameLabel.text = themeRecord.name;
    self.themeDescribeLabel.text = themeRecord.describe;
}

@end
