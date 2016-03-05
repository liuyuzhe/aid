//
//  AidDiscoverThemeShowView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/20.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverThemeShowView.h"

#import "Masonry.h"

#import "AidDiscoverThemeRecord.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;
static const CGFloat AidPhotoImageViewRadius = 20;

@interface AidDiscoverThemeShowView ()

@property (nonatomic, strong) UIView *bgContentView; /**< 背景内容视图 */
@property (nonatomic, strong) UIImageView *photoImageView; /**< 用户照片视图 */
@property (nonatomic, strong) UILabel *themeNameLabel; /**< 主题名称 */
@property (nonatomic, strong) UILabel *themeTimeLabel; /**< 主题起止时间 */

@property (nonatomic, strong) NSDateFormatter *formatter; /**< 日期格式化，添加为属性是为了优化性能 */

@end


@implementation AidDiscoverThemeShowView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupPageSubviews];
        
        [self addSubview:_bgContentView];
        [_bgContentView addSubview:_photoImageView];
        [_bgContentView addSubview:_themeNameLabel];
        [_bgContentView addSubview:_themeTimeLabel];
        
        [self layoutPageSubviews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - public methods

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _bgContentView = [[UIView alloc] init];
    _bgContentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AidPhotoImageViewRadius * 2, AidPhotoImageViewRadius * 2)];
    _photoImageView.image = [[UIImage imageNamed:@"about_praise"] imageWithRoundedCornerRadius:AidPhotoImageViewRadius andSize:_photoImageView.bounds.size];
//    _photoImageView.layer.cornerRadius = AidPhotoImageViewRadius;
//    _photoImageView.layer.borderWidth = 5;
//    _photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    _photoImageView.layer.masksToBounds = YES;
    
    _themeNameLabel = [[UILabel alloc] init];
    _themeNameLabel.font = AidBigFont;
    _themeNameLabel.textColor = [UIColor whiteColor];
    _themeNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _themeTimeLabel = [[UILabel alloc] init];
    _themeTimeLabel.font = AidNormalFont;
    _themeTimeLabel.textColor = [UIColor whiteColor];
    _themeTimeLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgContentView).mas_offset(AidViewDefaultOffset);
        make.centerY.equalTo(_bgContentView);
        make.size.mas_equalTo(CGSizeMake(AidPhotoImageViewRadius * 2, AidPhotoImageViewRadius * 2));
    }];
    
    [_themeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoImageView.mas_right).mas_offset(AidViewDefaultOffset);
        make.top.equalTo(_bgContentView).mas_offset(AidViewDefaultInset);
    }];
    
    [_themeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_photoImageView.mas_right).mas_offset(AidViewDefaultOffset);
        make.bottom.equalTo(_bgContentView).mas_offset(-AidViewDefaultInset);
    }];
}

#pragma mark - override super

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (NSDateFormatter *)formatter
{
    if (! _formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd EEE";
        _formatter.locale = [NSLocale currentLocale];
    }
    return _formatter;
}

- (void)setDiscoverThemeRecord:(AidDiscoverThemeRecord *)discoverThemeRecord
{
    _discoverThemeRecord = discoverThemeRecord;
    
//    self.photoImageView.image = [UIImage imageNamed:discoverThemeRecord.imageName];
    
    self.themeNameLabel.text = discoverThemeRecord.name;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSinceReferenceDate:discoverThemeRecord.createTime.doubleValue];
    self.themeTimeLabel.text = [self.formatter stringFromDate:createDate];
}

@end
