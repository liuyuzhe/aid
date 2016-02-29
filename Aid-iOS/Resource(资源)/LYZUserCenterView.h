//
//  LYZUserCenterView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/28.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LYZUserCenterHeaderViewDelegate <NSObject>

@optional
- (void)didClickToLogin;
- (void)didClickToEnterUserCenter;

@end


typedef NS_ENUM(NSInteger, LYZHeaderViewState)
{
    LYZHeaderViewStateNone = 0,
    LYZHeaderViewStateLogin,
};

@interface LYZUserCenterView : UIView

@property (nonatomic, weak) id<LYZUserCenterHeaderViewDelegate> delegate;
@property (nonatomic, assign) LYZHeaderViewState state;

@end
