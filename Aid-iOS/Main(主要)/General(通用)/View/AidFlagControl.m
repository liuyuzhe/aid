//
//  AidFlagControl.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/3.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidFlagControl.h"

@interface AidFlagControl()

@property (nonatomic, strong) UIImageView *noStateImageView;
@property (nonatomic, strong) UIImageView *yesStateImageView;
@property (nonatomic, strong) UIImageView *defaultStateImageView;

@property (nonatomic, assign, readwrite) AidFlagControlState currentFlag;

@end


@implementation AidFlagControl

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.currentFlag = AidFlagControlStateNO;
        
        [self setupPageSubviews];
        
        [self addSubview:_noStateImageView];
        [self addSubview:_yesStateImageView];
        [self addSubview:_defaultStateImageView];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - public methods

- (void)setFlag:(AidFlagControlState)flag withAnimation:(BOOL)animation
{
    if (animation) {
        // no --> yes
        if (self.currentFlag == AidFlagControlStateNO && flag == AidFlagControlStateYES) {
            self.yesStateImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            
            [UIView animateWithDuration:0.3 animations:^{
                self.noStateImageView.alpha = 0.0;
                self.yesStateImageView.alpha = 1.0;
                self.yesStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                self.noStateImageView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
            } completion:^(BOOL finished) {
                self.yesStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                self.noStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }
        // yes --> no
        else if(self.currentFlag == AidFlagControlStateYES && flag == AidFlagControlStateNO) {
            self.noStateImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            [UIView animateWithDuration:0.3 animations:^{
                self.noStateImageView.alpha = 1.0;
                self.yesStateImageView.alpha = 0.0;
                self.yesStateImageView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                self.noStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                self.yesStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                self.noStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }
    }
    else {
        // no --> yes
        if (self.currentFlag == AidFlagControlStateNO && flag == AidFlagControlStateYES) {
            self.noStateImageView.alpha = 0.0;
            self.yesStateImageView.alpha = 1.0;
            self.yesStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.noStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }
        // yes --> no
        else if(self.currentFlag == AidFlagControlStateYES && flag == AidFlagControlStateNO) {
            self.noStateImageView.alpha = 1.0;
            self.yesStateImageView.alpha = 0.0;
            self.yesStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.noStateImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }
    }
    
    self.currentFlag = flag;
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    _noStateImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _noStateImageView.contentMode = UIViewContentModeCenter;
    
    _yesStateImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _yesStateImageView.contentMode = UIViewContentModeCenter;
    _yesStateImageView.alpha = 0.0;
    
    _defaultStateImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _defaultStateImageView.contentMode = UIViewContentModeCenter;
}

- (void)layoutPageSubviews
{
}

#pragma mark - override super

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setNoStateImage:(UIImage *)noStateImage
{
    self.noStateImageView.image = noStateImage;
    _noStateImage = noStateImage;
}

- (void)setYesStateImage:(UIImage *)yesStateImage
{
    self.yesStateImageView.image = yesStateImage;
    _yesStateImage = yesStateImage;
}

- (void)setDefaultStateImage:(UIImage *)defaultStateImage
{
    self.defaultStateImageView.image = defaultStateImage;
    _defaultStateImage = defaultStateImage;
}

@end
