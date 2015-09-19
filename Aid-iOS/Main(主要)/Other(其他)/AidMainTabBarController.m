//
//  AidMainTabBarController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/19.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidMainTabBarController.h"

@interface AidMainTabBarController () <UITabBarControllerDelegate>

@end

@implementation AidMainTabBarController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self setUpAllChildViewController];
    
    self.delegate = self;
}

- (void)setUpAllChildViewController
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - override super

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITabBarControllerDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
