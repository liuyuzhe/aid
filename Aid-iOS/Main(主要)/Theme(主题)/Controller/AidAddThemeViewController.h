//
//  AidAddThemeViewController.h
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import <UIKit/UIKit.h>

#import "AidThemeRecord.h"

@protocol AidAddThemeViewControllerDelegate <NSObject>

@optional
- (void)addThemeRecord:(AidThemeRecord *)record;

@end

@interface AidAddThemeViewController : UIViewController

@property (nonatomic, weak) id<AidAddThemeViewControllerDelegate> delegate;

@end
