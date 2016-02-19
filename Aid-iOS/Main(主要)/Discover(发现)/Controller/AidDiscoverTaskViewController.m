//
//  AidDiscoverTaskViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverTaskViewController.h"

#import "AidCarouselView.h"
#import "AidDiscoverTaskCell.h"

#import "AidDiscoverTaskTable.h"

#import "UINavigationBar+Awesome.h"
#import "UIView+LYZMasonyCategory.h"

static const CGFloat AidHeadViewHeigtht = 235;
static const CGFloat AidNavbarChangePoint = 50;

@interface AidDiscoverTaskViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) NSMutableArray<AidDiscoverTaskRecord *> *discoverTaskArray;

@property (nonatomic, strong) dispatch_semaphore_t discoverTaskSemaphore;
@property (nonatomic, strong) dispatch_queue_t writeDiscoverTaskSerilQueue;
@property (nonatomic, strong) AidDiscoverTaskTable *discoverTaskTable;

@end


@implementation AidDiscoverTaskViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _discoverTaskSemaphore = dispatch_semaphore_create(1);
        _writeDiscoverTaskSerilQueue = dispatch_queue_create("com.dispatch.writeTask.AidTaskViewController", DISPATCH_QUEUE_SERIAL);

        self.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    }
    return self;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = contentView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.extendedLayoutIncludesOpaqueBars = YES;
    
    //    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    [self.headView addSubview:self.headImageView];
    
    [self layoutPageSubviews];
    
    [self reloadDiscoverTaskData];
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
    AidDiscoverTaskCell *cell = [AidDiscoverTaskCell cellWithTableView:tableView];
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
    //    AidHotDetailViewController *hotDetailVC = [[AidHotDetailViewController alloc] init];
    //    [self.navigationController pushViewController:hotDetailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
    headerView.backgroundColor = [UIColor blueColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
    footerView.backgroundColor = [UIColor greenColor];
    return footerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 计算当前偏移位置
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 导航栏透明渐变
    UIColor * color = [UIColor purpleColor];
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
}

#pragma mark - event response

- (void)searchBarAction:(UIButton *)button
{
}

#pragma mark - notification response

#pragma mark - private methods

- (void)reloadDiscoverTaskData
{
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        NSError *error = nil;
        NSString *sqlString = @"SELECT * FROM :tableName WHERE :themeID = :themeKey;";
        NSString *tableName = [self.discoverTaskTable tableName];
        NSString *themeID = @"themeID";
        NSNumber *themeKey = self.themeKey;
        NSDictionary *params = NSDictionaryOfVariableBindings(tableName, themeID, themeKey);
        NSArray *fetchedRecordList = [self.discoverTaskTable findAllWithSQL:sqlString params:params error:&error];
        
        if ([fetchedRecordList count] > 0 && error == nil) {
            [self.discoverTaskArray removeAllObjects];
            [self.discoverTaskArray addObjectsFromArray:fetchedRecordList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
}

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight]) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
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

- (NSMutableArray<AidDiscoverTaskRecord *> *)discoverTaskArray
{
    if (! _discoverTaskArray) {
        _discoverTaskArray = [NSMutableArray array];
    }
    return _discoverTaskArray;
}

- (AidDiscoverTaskTable *)discoverTaskTable
{
    if (! _discoverTaskTable) {
        _discoverTaskTable = [[AidDiscoverTaskTable alloc] init];
    }
    return _discoverTaskTable;
}

@end
