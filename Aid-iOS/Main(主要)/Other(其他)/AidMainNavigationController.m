//
//  AidMainNavigationController.m
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import "AidMainNavigationController.h"

@interface AidMainNavigationController ()

@end

@implementation AidMainNavigationController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationBar.translucent = NO; // 默认为透明（设置为YES），坐标零点默认在（0，0）。当不透明时（设置为NO），坐标零点在（0，64）。如果设置成透明的，而且还要零点从（0，64）开始，在 UIViewController 中添加：self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationBar.tintColor = AidNavigationTintColor;
    self.navigationBar.barTintColor = AidNavigationBarTintColor;
    self.navigationBar.titleTextAttributes = @{
                                               NSForegroundColorAttributeName : AidNavigationForegroundColor,
                                               NSFontAttributeName : AidNavigationFont
                                               };
    
//    if ([LYZDeviceInfo systemVersionGreaterThanOrEqualTo:@"7.0"]) {
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""]
//                                          forBarPosition:UIBarPositionTop
//                                              barMetrics:UIBarMetricsDefault];
//    }
//    else {
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - override super

#pragma mark - UITabBarControllerDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
