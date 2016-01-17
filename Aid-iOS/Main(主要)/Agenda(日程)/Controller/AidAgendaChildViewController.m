//
//  AidAgendaChildViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidAgendaChildViewController.h"

#import "AidAgendaTaskCell.h"

#import "AidAgendaTable.h"

@interface AidAgendaChildViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<AidAgendaRecord *> *taskArray;

@end


@implementation AidAgendaChildViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:LYZScreenBounds];
    self.view = contentView;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    
    [self layoutPageSubviews];
    
    [self loadThemeData];
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
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidAgendaTaskCell *cell = [AidAgendaTaskCell cellWithTableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
//    headerView.backgroundColor = [UIColor blueColor];
//    return headerView;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 0)];
//    footerView.backgroundColor = [UIColor greenColor];
//    return footerView;
//}

#pragma mark - UIScrollViewDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

- (void)loadThemeData
{
    //    AidThemeTable *table = [[AidThemeTable alloc] init];
    //    NSError *error = nil;
    //
    //    NSString *whereCondition = @":primaryKey > 0";
    //    NSString *primaryKey = [table primaryKeyName];
    //    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKey);
    //    NSArray *fetchedRecordList = [table findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    //    if ([fetchedRecordList count] > 0 && error == nil) {
    //        NSLog(@"2001 success");
    //    } else {
    //        NSException *exception = [[NSException alloc] init];
    //        @throw exception;
    //    }
    //
    //    [self.themeArray removeAllObjects];
    //    [self.themeArray addObjectsFromArray:fetchedRecordList];
    //    [self.tableView reloadData];
}

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, AidTabBarHeight, 0); // 添加额外滚动区域
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 将系统的Separator左边不留间隙
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    return _tableView;
}

- (NSMutableArray<AidAgendaRecord *> *)taskArray
{
    if (! _taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

@end
