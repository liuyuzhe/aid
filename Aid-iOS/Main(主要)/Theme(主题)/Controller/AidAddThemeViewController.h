//
//  AidAddThemeViewController.h
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import <UIKit/UIKit.h>

@class AidThemeRecord;

@protocol AidAddThemeViewControllerDelegate <NSObject>

@optional
- (void)addThemeRecord:(AidThemeRecord *)themeRecord;

@end


@interface AidAddThemeViewController : UIViewController

@property (nonatomic, weak) id<AidAddThemeViewControllerDelegate> delegate;

@end
