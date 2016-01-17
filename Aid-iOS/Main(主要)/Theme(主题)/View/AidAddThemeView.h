//
//  AidAddThemeView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AidAddThemeViewDelegate <NSObject>

@optional
- (void)cancelButtonTouched:(UIButton *)button;
- (void)completeButtonTouched:(UIButton *)button;

@end


@interface AidAddThemeView : UIView

@property (nonatomic, weak) id<AidAddThemeViewDelegate> delegate;

@end
