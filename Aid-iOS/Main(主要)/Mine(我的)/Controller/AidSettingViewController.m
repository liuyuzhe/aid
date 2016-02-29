//
//  AidSettingViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/28.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidSettingViewController.h"

#import "AidSettingCell.h"

static const CGFloat AidSettingCellHeight = 44;

@interface AidSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIButton *logoutButton;

@end


@implementation AidSettingViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = contentView;
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.logoutButton];
    
    [self layoutPageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle helper

- (void)setupPageNavigation
{
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBarAction:)];
    self.navigationItem.rightBarButtonItem = completeItem;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf);
//        make.bottom.equalTo(self.logoutButton);
//    }];
//    
//    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(weakSelf);
//        make.height.equalTo(@49);
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 3;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidSettingCell *cell = [AidSettingCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"给个好评";
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"意见反馈";
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"版本";
            cell.detailTextLabel.text = @"1.0";
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AidSettingCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FotterView"];
    if (! view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"FotterView"];
        view.backgroundView = [UIView new];
    }
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    if (! view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderView"];
        view.backgroundView = [UIView new];
    }
    return view;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0){
        return  YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"1075823384"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - UIScrollViewDelegate

#pragma mark - event response

- (void)completeBarAction:(UIBarButtonItem *)barButton
{
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, AidNavigationHeadHeight, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - AidNavigationHeadHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 将系统的Separator左边不留间隙
//        _tableView.separatorInset = UIEdgeInsetsZero;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        _tableView.tableHeaderView = [[UIView alloc] init];
//        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableFooterView = self.logoutButton;
    }
    return _tableView;
}

- (UIButton *)logoutButton
{
    if (! _logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidTabBarHeight);
        [_logoutButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[[UIImage imageNamed:@"btn_default_red"] stretchImageWithEdge:2] forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[[UIImage imageNamed:@"btn_focus_red"] stretchImageWithEdge:2] forState:UIControlStateHighlighted];
    }
    return _logoutButton;
}

@end
