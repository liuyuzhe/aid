//
//  LYZWeatherBasicInfoView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/27.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZWeatherBasicInfoView.h"

static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;

@interface LYZWeatherBasicInfoView ()

@property (nonatomic, strong) UIView *weatherView;
@property (nonatomic, strong) UIImageView *weatherImage;
@property (nonatomic, strong) UILabel *weatherLabel;

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *tempLabel;

@end


@implementation LYZWeatherBasicInfoView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageSubviews];
        
//        [self addSubview:_weatherView];
//        [self addSubview:_weatherImage];
        [self addSubview:_weatherLabel];
        [self addSubview:_cityLabel];
//        [self addSubview:_dateLabel];
        [self addSubview:_tempLabel];
        
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
    _weatherView = [[UIView alloc]init];
    _weatherView.layer.cornerRadius = 15;
    _weatherView.backgroundColor = [UIColor colorWithHexString:@"#122f52"];

    _weatherImage = [[UIImageView alloc]init];

    _weatherLabel = [[UILabel alloc]init];
    _weatherLabel.font = [UIFont systemFontOfSize:14];
    _weatherLabel.textColor = [UIColor colorWithRed:0.32 green:0.66 blue:0.84 alpha:1];
    _weatherLabel.textAlignment = NSTextAlignmentCenter;

    _cityLabel = [[UILabel alloc]init];
    _cityLabel.font = [UIFont systemFontOfSize:32];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;

    _tempLabel = [[UILabel alloc]init];
    _tempLabel.font = [UIFont systemFontOfSize:82];
    _tempLabel.textColor = [UIColor whiteColor];
    _tempLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
    
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.centerY.equalTo(weakSelf);
    }];
    
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-AidViewDefaultOffset);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - override super

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setWeatherModel:(LYZWeatherDataModel *)weatherModel
{
    _weatherModel = weatherModel;
    
    self.weatherLabel.text = weatherModel.weather;
    self.cityLabel.text = weatherModel.city;
    self.dateLabel.text = weatherModel.date;
    self.tempLabel.text = weatherModel.temp;
}

@end
