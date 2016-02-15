//
//  AidEditTaskViewController.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/24.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLFormViewController.h"

@class AidEditTaskViewController;
@class AidTaskRecord;

@protocol AidEditTaskViewControllerDelegate <NSObject>

@optional
- (void)editTaskRecord:(AidTaskRecord *)taskRecord configureViewController:(AidEditTaskViewController *)viewController;

@end


@interface AidEditTaskViewController : XLFormViewController

@property (nonatomic, strong) AidTaskRecord *taskRecord;
@property (nonatomic, weak) id<AidEditTaskViewControllerDelegate> delegate;

@end
