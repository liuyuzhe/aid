//
//  AidOperateTaskView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/25.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AidOperateTaskViewDelegate <NSObject>

@optional
- (void)multipleButtonTouched:(UIButton *)button withIndex:(NSInteger)index;

@end


@interface AidOperateTaskView : UIView

@property (nonatomic, weak) id<AidOperateTaskViewDelegate> delegate;

/** @attention titleNames.count == imageNames.count 且 >= 2 */
- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray <NSString *> *)titleNames imageNames:(NSArray <NSString *> *)imageNames;

@end
