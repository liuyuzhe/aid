//
//  AidThemeViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidThemeViewController.h"
#import "AidAddThemeView.h"
#import "Masonry.h"

@interface AidThemeViewController () <AidAddThemeViewDelegate>

@property (nonatomic, strong) AidAddThemeView *addThemeView;

@end


@implementation AidThemeViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    
    self.title = @"主题";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.addThemeView];
    
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
    
    [self.addThemeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
    }];
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

- (AidAddThemeView *)addThemeView
{
    if (! _addThemeView) {
        _addThemeView = [[AidAddThemeView alloc] initWithFrame:self.view.bounds];
        _addThemeView.delegate = self;
    }
    return _addThemeView;
}

@end
