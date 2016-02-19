//
//  AidMineViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/26.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidMineViewController.h"

#import "UINavigationBar+Awesome.h"

static const CGFloat AidHeadViewHeigtht = 235;
static const CGFloat AidNavbarChangePoint = 50;

@interface AidMineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UIImageView *photoImageView;

@end


@implementation AidMineViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = contentView;
    
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    [self.headView addSubview:self.headImageView];
    [self.headView addSubview:self.photoImageView];
    
    [self layoutPageSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.tableView]; // 还原 navigationController.navigationBar

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle helper

- (void)setupPageNavigation
{
    UIBarButtonItem *searchItem = [UIBarButtonItem initWithNormalImage:@"icon_homepage_search" target:self action:@selector(searchBarAction:) width:24 height:24];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    // 设置展示图片的约束
//    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.mas_top);
//        make.left.equalTo(weakSelf.mas_left);
//        make.right.equalTo(weakSelf.mas_right);
//    }];
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.hotArray.count;
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const identifier = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"今日任务";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    AidHotDetailViewController *hotDetailVC = [[AidHotDetailViewController alloc] init];
    //    [self.navigationController pushViewController:hotDetailVC animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
//    headerView.backgroundColor = [UIColor blueColor];
//    return headerView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
//    footerView.backgroundColor = [UIColor greenColor];
//    return footerView;
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 计算当前偏移位置
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 导航栏透明渐变
    UIColor * color = AidNavigationBarTintColor;
    if (offsetY > AidNavbarChangePoint) {
        CGFloat alpha = MIN(1, 1 - ((AidNavbarChangePoint + AidNavigationHeadHeight - offsetY) / AidNavigationHeadHeight));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[AidNavigationForegroundColor colorWithAlphaComponent:alpha]};
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[AidNavigationForegroundColor colorWithAlphaComponent:0]};
    }
    
    // 展示图片下拉缩放
    if (offsetY < 0) {
        self.headView.frame = CGRectMake(0, offsetY, [LYZDeviceInfo screenWidth], AidHeadViewHeigtht - offsetY);
        self.headImageView.frame = CGRectMake(0, offsetY, [LYZDeviceInfo screenWidth], AidHeadViewHeigtht - offsetY);
    }
    
//    CGFloat height = -offsetY;
//    if (height < AidNavHeadHeigtht) {
//        height = AidNavHeadHeigtht;
//    }
//    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
}

#pragma mark - event response

- (void)searchBarAction:(UIButton *)button
{
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight]) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.contentInset = UIEdgeInsetsMake(AidHeadViewHeigtht, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 将系统的Separator左边不留间隙
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIView *)headView
{
    if (! _headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidHeadViewHeigtht)];
    }
    return _headView;
}

- (UIImageView *)headImageView
{
    if (! _headImageView) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidHeadViewHeigtht)];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"backImage1.jpg"];
    }
    return _headImageView;
}

- (UIImageView *)photoImageView
{
    if (! _photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake([LYZDeviceInfo screenWidth] / 2 - 50, 50, 100, 100)];
        _photoImageView.image = [UIImage imageNamed:@"about_praise"];
        _photoImageView.layer.cornerRadius = 50;
        _photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _photoImageView.layer.borderWidth = 5;
        _photoImageView.layer.masksToBounds = YES;
    }
    return _photoImageView;
}

@end
