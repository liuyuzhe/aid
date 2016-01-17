//
//  AidFlagControl.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/3.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AidFlagControlState) {
    AidFlagControlStateNO = 0,
    AidFlagControlStateYES = 1,
    AidFlagControlStateDefault = 2,
};

@interface AidFlagControl : UIControl

@property (nonatomic, strong) UIImage *noStateImage;
@property (nonatomic, strong) UIImage *yesStateImage;
@property (nonatomic, strong) UIImage *defaultStateImage;

@property (nonatomic, assign, readonly) AidFlagControlState flag;


- (void)setFlag:(AidFlagControlState)flag withAnimation:(BOOL)animation;

@end
