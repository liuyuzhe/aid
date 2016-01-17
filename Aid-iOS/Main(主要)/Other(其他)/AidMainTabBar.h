//
//  AidMainTabBar.h
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import <UIKit/UIKit.h>

#import "AidTabBarButton.h"

@class AidMainTabBar;

@protocol tabbarDelegate <NSObject>

@optional
- (void)tabBar:(AidMainTabBar *)tabBar didselectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end



@interface AidMainTabBar : UIView

@property (nonatomic , weak) AidTabBarButton *selectedButton;
@property (nonatomic , weak) id<tabbarDelegate> delegate;

-(void)addTabBarButtonWithItem:(UITabBarItem *)itme;

@end
