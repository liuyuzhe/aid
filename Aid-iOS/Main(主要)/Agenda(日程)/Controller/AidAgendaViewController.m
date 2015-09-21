//
//  AidAgendaViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/21.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidAgendaViewController.h"
#import "Masonry.h"

@interface AidAgendaViewController ()

@end

@implementation AidAgendaViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    
    self.title = @"日程";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutPageSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle helper

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

#pragma mark - AidAddThemeViewDelegate

- (void)addButtonTouched:(UIButton *)button;
{
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
