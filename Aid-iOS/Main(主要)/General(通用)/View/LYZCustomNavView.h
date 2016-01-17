//
//  LYZCustomNavView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^customNavViewAction)(UIButton *button);

@interface LYZCustomNavView : UIView

@property (nonatomic, copy) customNavViewAction cancelButtonTouched;
@property (nonatomic, copy) customNavViewAction completeButtonTouched;

@end
