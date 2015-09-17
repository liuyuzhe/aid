//
//  LYZMainTabBarController.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/4.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZMainTabBarController.h"
#import "LYZArrangeListViewController.h"
#import "LYZProjectListViewController.h"
#import "LYZContactsViewController.h"
#import "LYZMoreViewController.h"
#import "DCPathButton.h"

@interface LYZMainTabBarController () <UITabBarControllerDelegate, DCPathButtonDelegate>

@property (nonatomic, strong) DCPathButton *curveMenu;

@end


@implementation LYZMainTabBarController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    LYZArrangeListViewController *recentVC = [[LYZArrangeListViewController alloc] init];
    LYZProjectListViewController *mostVC = [[LYZProjectListViewController alloc] init];
    LYZContactsViewController * contactVC = [[LYZContactsViewController alloc] init];
    LYZMoreViewController *moreVC = [[LYZMoreViewController alloc] init];
    UIViewController *unuseVC = [[UIViewController alloc] init];
    
    recentVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    mostVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    contactVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3];
    moreVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:4];
    unuseVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:nil tag:-1]; // Warning: Use tag is not accurate
    
    UINavigationController *recentNav = [[UINavigationController alloc] initWithRootViewController:recentVC];
    UINavigationController *mostNav = [[UINavigationController alloc] initWithRootViewController:mostVC];
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactVC];
    UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController:moreVC];
    UINavigationController *unuseNav = [[UINavigationController alloc] initWithRootViewController:unuseVC];

    self.viewControllers = @[recentNav, mostNav, unuseNav, contactNav, moreNav];

    [self.tabBar.superview addSubview:self.curveMenu];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - override super

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    // Warning: Don't use tabBarItem.tag, because it is not accurate.
    if (tabBarController.viewControllers[2] == viewController) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - DCPathButtonDelegate

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    NSLog(@"You tap at index : %zd", index);
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (DCPathButton *)curveMenu
{
    if (! _curveMenu) {
        // Configure center button
        _curveMenu = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                            hilightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
        // Configure item buttons
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        // Add the item button into the center button
        [_curveMenu addPathItems:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
        
        // Change the bloom radius
        _curveMenu.bloomRadius = 120.0f;
        
        // Change the DCButton's center
        _curveMenu.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
        
        _curveMenu.bloomDirection = DCPathButtonBloomTop;
        
        // Setting the DCButton appearance
        _curveMenu.soundsEnable = NO;
        _curveMenu.centerBtnRotationEnable = YES;
        
        _curveMenu.delegate = self;
    }
    return _curveMenu;
}

@end
