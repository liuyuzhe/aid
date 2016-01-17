//
//  AidOperateTaskView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/25.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^multipleButtonAction)(NSInteger index);

@interface AidOperateTaskView : UIView

@property (nonatomic, copy) multipleButtonAction buttonTouched;

/** @attention imageNames.count == titleNames.count 且 >= 2 */
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray <NSString *> *)imageNames titleNames:(NSArray <NSString *> *)titleNames;

@end
