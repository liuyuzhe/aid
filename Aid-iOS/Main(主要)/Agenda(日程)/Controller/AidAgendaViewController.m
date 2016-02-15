//
//  AidAgendaViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/21.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidAgendaViewController.h"
#import "AidAgendaChildViewController.h"

@interface AidAgendaViewController ()

@end


@implementation AidAgendaViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = contentView;
    
    self.title = @"日程";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [self setUpAllViewController];
    
    // 滚动视图设置
    self.titleScrollViewColor = [UIColor grayColor];
    
    // 标题设置
    self.normalColor = [UIColor whiteColor];
    self.selectColor = [UIColor orangeColor];
    
    // 遮盖视图设置
    self.showTitleCover = YES;
    self.coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    self.coverCornerRadius = 10;
    self.delayScrollCover = NO;
    
    [super viewDidLoad]; // 必须先构建完所有子视图控制器后,才能调用viewDidLoad
    
    [self setupPageNavigation];

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

- (void)setUpAllViewController
{
    NSArray *titleNames = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (NSString *title in titleNames) {
        AidAgendaChildViewController *childVC = [[AidAgendaChildViewController alloc] init];
        childVC.title = title;
        
        [self addChildViewController:childVC];
    }
}

- (void)setupPageNavigation
{
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
