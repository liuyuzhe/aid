//
//  AidDiscoverThemeCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverThemeCell.h"
#import "Masonry.h"

#import "LYZVerticalButton.h"

#import "AidDiscoverThemeRecord.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;

@interface AidDiscoverThemeCell ()

@property (nonatomic, strong) UIView *bgContentView; /**< 背景内容视图 */
@property (nonatomic, strong) UIImageView *themeImageView; /**< 主题图片 */
@property (nonatomic, strong) UILabel *themeNameLabel; /**< 主题名称 */
@property (nonatomic, strong) UILabel *themeDescribeLabel; /**< 主题描述 */
@property (nonatomic, strong) LYZVerticalButton *storeButton; /**< 是否收藏 */

@end


@implementation AidDiscoverThemeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * const identifier = NSStringFromClass([AidDiscoverThemeCell class]);
    AidDiscoverThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[AidDiscoverThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        [_bgContentView addSubview:_storeButton];

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
    _themeNameLabel.textColor = [UIColor blackColor];
    _themeNameLabel.textAlignment = NSTextAlignmentCenter;
    
    _themeDescribeLabel = [[UILabel alloc] init];
    _themeDescribeLabel.font = AidNormalFont;
    _themeNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _storeButton = [[LYZVerticalButton alloc] init];
    _storeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_storeButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_storeButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [_storeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_storeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_storeButton setImage:[UIImage imageNamed:@"add_group"] forState:UIControlStateNormal];
    [_storeButton setImage:[UIImage imageNamed:@"address_checked"] forState:UIControlStateSelected];
    [_storeButton addTarget:self action:@selector(storeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [_storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgContentView).mas_offset(- AidViewDefaultInset);
        make.centerY.equalTo(_bgContentView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
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

#pragma mark - event response

- (void)storeButtonAction:(UIButton *)button
{
    self.storeButton.selected = ! self.storeButton.selected;
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setDiscoverThemeRecord:(AidDiscoverThemeRecord *)discoverThemeRecord
{
    _discoverThemeRecord = discoverThemeRecord;
    
    self.themeImageView.image = [UIImage imageNamed:discoverThemeRecord.imageName];
    self.themeNameLabel.text = discoverThemeRecord.name;
    self.themeDescribeLabel.text = discoverThemeRecord.describe;
}

@end
