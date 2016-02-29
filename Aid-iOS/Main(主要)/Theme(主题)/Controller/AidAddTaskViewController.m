//
//  AidAddTaskViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidAddTaskViewController.h"

#import "AidWeekDayCell.h"
#import "AidTextFieldCell.h"

@interface AidAddTaskViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation AidAddTaskViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = contentView;
    self.title = @"增加任务";

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    
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

- (void)setupPageNavigation
{
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
    }];
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AidTextFieldCell *cell = [AidTextFieldCell cellWithTableView:tableView];
        cell.cellStyle = AidTextFieldCellStyleNoEnable;
        cell.placeholder = @"名称";
        return cell;
    }
    else {
    
    AidWeekDayCell *cell = [AidWeekDayCell cellWithTableView:tableView];
//    __weak typeof(self) weakSelf = self;
    cell.weekDayTouched = ^(NSDictionary *dictionary) {
        LYZPRINT(@":%@", dictionary);
    };
    
    return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 88;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
    return headerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
