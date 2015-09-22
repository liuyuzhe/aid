//
//  AidMainTabBarController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/19.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidMainTabBarController.h"
#import "AidAgendaViewController.h"
#import "AidThemeViewController.h"

@interface AidMainTabBarController () <UITabBarControllerDelegate>

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
    AidAgendaViewController *agendaVC = [[AidAgendaViewController alloc] init];
    UINavigationController *agendaNav = [[UINavigationController alloc] initWithRootViewController:agendaVC];
    
    AidThemeViewController *themeVC = [[AidThemeViewController alloc] init];
    UINavigationController *themeNav = [[UINavigationController alloc] initWithRootViewController:themeVC];
    
    self.viewControllers = @[agendaNav, themeNav];
}

#pragma mark - override super

#pragma mark - UITabBarControllerDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
