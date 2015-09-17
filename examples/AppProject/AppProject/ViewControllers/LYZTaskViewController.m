//
//  LYZTaskViewController.m
//  AppProject
//
//  Created by 刘育哲 on 15/9/16.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZTaskViewController.h"
#import "Masonry.h"

@interface LYZTaskViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView;

@end


@implementation LYZTaskViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.collectView];

    [self layoutPageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

#pragma mark - life cycle helper

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
}

#pragma mark - UITableViewDataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark - UIScrollViewDelegate

#pragma mark - event response


#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UICollectionView *)collectView
{
    if (_collectView) {
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, 250, 350)];
        _collectView.backgroundColor = [UIColor grayColor];
        _collectView.delegate = self;
        _collectView.dataSource = self;
    }
    return _collectView;
}
     
@end
