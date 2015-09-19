//
//  LYZArrangeListViewController.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZArrangeListViewController.h"
#import "Masonry.h"

@interface LYZArrangeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *searchButton;

@property (nonatomic, strong) NSArray *customList;
@property (nonatomic, strong) NSArray *timeOfList;
@property (nonatomic, strong) NSArray *stateOfList;

@end


@implementation LYZArrangeListViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    
    self.title = @"整理";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customList = @[@"收件箱", @"星标", @"地点", @"提醒"];
    self.timeOfList = @[@"今天", @"明天", @"已排期", @"未排期"];
    self.stateOfList = @[@"未完成", @"已完成", @"所有", @"回收站"];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    [self.view addSubview:self.tableView];
    
    [self layoutPageSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - life cycle helper

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    switch (section) {
        case 0:
            count = [self.customList count];
            break;
        case 1:
            count = [self.timeOfList count];
            break;
        case 2:
            count = [self.stateOfList count];
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const identifier = NSStringFromClass([UITableViewCell class]);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = self.customList[indexPath.row];
                break;
            case 1:
                cell.textLabel.text = self.timeOfList[indexPath.row];
                break;
            case 2:
                cell.textLabel.text = self.stateOfList[indexPath.row];
                break;
                
            default:
                break;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[self navigationController] pushViewController:self.listVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

#pragma mark - event response

- (void)searchAction:(UIBarButtonItem *)barButton
{
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIBarButtonItem *)searchButton
{
    if (! _searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    }
    return _searchButton;
}

@end
