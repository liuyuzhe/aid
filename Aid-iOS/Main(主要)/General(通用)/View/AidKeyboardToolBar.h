//
//  AidKeyboardToolBar.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/20.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AidKeyboardToolBar;

@protocol AidKeyboardToolBarDelegate <NSObject>

@optional;
- (void)keyboardToolBar:(AidKeyboardToolBar *)toolBar didClickPreviousItem:(UIBarButtonItem *)item;
- (void)keyboardToolBar:(AidKeyboardToolBar *)toolBar didClickNextItem:(UIBarButtonItem *)item;
- (void)keyboardToolBar:(AidKeyboardToolBar *)toolBar didClickDoneItem:(UIBarButtonItem *)item;

@end


@interface AidKeyboardToolBar : UIToolbar

@property (nonatomic ,weak) id<AidKeyboardToolBarDelegate> keyboardDelegate;

@end
