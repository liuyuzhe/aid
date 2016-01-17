//
//  AidMainTabBarController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/19.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidMainTabBarController.h"
#import "AidMainNavigationController.h"

#import "AidAgendaViewController.h"
#import "AidThemeViewController.h"
#import "AidDiscoverViewController.h"
#import "AidMineViewController.h"

#import "AidMainTabBar.h"

@interface AidMainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) AidMainTabBar *mainTabBar;

@end


@implementation AidMainTabBarController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpAllChildViewController];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle helper

- (void)setUpAllChildViewController
{
    AidThemeViewController *themeVC = [[AidThemeViewController alloc] init];
    [self setupChildViewController:themeVC title:@"主题" imageName:@"icon_tabbar_onsite" seleceImageName:@"icon_tabbar_onsite_selected"];
    
    AidAgendaViewController *agendaVC = [[AidAgendaViewController alloc] init];
    [self setupChildViewController:agendaVC title:@"日程" imageName:@"icon_tabbar_homepage" seleceImageName:@"icon_tabbar_homepage_selected"];
    
    AidDiscoverViewController *discoverVC = [[AidDiscoverViewController alloc]init];
    [self setupChildViewController:discoverVC title:@"发现" imageName:@"icon_tabbar_merchant_normal" seleceImageName:@"icon_tabbar_merchant_normal_selected"];
    
    AidMineViewController *mineVC = [[AidMineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_tabbar_mine" seleceImageName:@"icon_tabbar_mine_selected"];
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName
{
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    
    //包装导航控制器
//    AidMainNavigationController *nav = [[AidMainNavigationController alloc] initWithRootViewController:controller];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    [self addChildViewController:nav];
    
    [self.mainTabBar addTabBarButtonWithItem:controller.tabBarItem];
}

#pragma mark - override super

#pragma mark - UITabBarControllerDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
