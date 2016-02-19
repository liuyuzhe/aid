//
//  AidDiscoverThemeViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverThemeViewController.h"
#import "AidDiscoverTaskViewController.h"

#import "AidCarouselView.h"
#import "AidDiscoverThemeCell.h"

#import "AidDiscoverThemeTable.h"

static const CGFloat AidParallaxHeaderHeight = 190;

@interface AidDiscoverThemeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AidCarouselView *carouseView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray<AidDiscoverThemeRecord *> *discoverThemeArray;
@property (nonatomic, strong) NSArray<UIImage *> *imageArray;

@property (nonatomic, strong) dispatch_semaphore_t discoverThemeSemaphore;
@property (nonatomic, strong) dispatch_queue_t writeDiscoverThemeSerilQueue;
@property (nonatomic, strong) AidDiscoverThemeTable *discoverThemeTable;

@end


@implementation AidDiscoverThemeViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _discoverThemeSemaphore = dispatch_semaphore_create(1);
        _writeDiscoverThemeSerilQueue = dispatch_queue_create("com.dispatch.writeDiscoverTheme.AidDiscoverThemeViewController", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

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
    [self.tableView addSubview:self.pageControl];
    
    [self layoutPageSubviews];
    
    [self reloadDiscoverThemeData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.carouseView startMoving];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.carouseView stopMoving];
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
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.discoverThemeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidDiscoverThemeCell *cell = [AidDiscoverThemeCell cellWithTableView:tableView];
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
    AidDiscoverTaskViewController *discoverTaskVC = [[AidDiscoverTaskViewController alloc] init];
    discoverTaskVC.title = self.title;
    AidDiscoverThemeRecord *record = self.discoverThemeArray[indexPath.row];
    discoverTaskVC.themeKey = record.primaryKey;

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:discoverTaskVC animated:YES];
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

- (void)didTouchPageIndex:(NSInteger)pageIndex
{
    LYZINFO(@"carouseView did touch No.%ld page", pageIndex);
}

- (void)didMoveToPageIndex:(NSInteger)pageIndex
{
    LYZINFO(@"carouseView did move to No.%ld page", pageIndex);
    
    self.pageControl.currentPage = pageIndex;
}

#pragma mark - notification response

#pragma mark - private methods

- (void)reloadDiscoverThemeData
{
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        NSError *error = nil;
        NSString *condition = @":themeType = :themeKind";
        NSString *themeType = @"themeType";
        NSString *themeKind = self.title;
        NSDictionary *params = NSDictionaryOfVariableBindings(themeType, themeKind);
        NSArray *fetchedRecordList = [self.discoverThemeTable findAllWithWhereCondition:condition conditionParams:params isDistinct:NO error:&error];
        
        if (fetchedRecordList.count > 0 && error == nil) {
            dispatch_semaphore_wait(self.discoverThemeSemaphore, DISPATCH_TIME_FOREVER);
            [self.discoverThemeArray removeAllObjects];
            [self.discoverThemeArray addObjectsFromArray:fetchedRecordList];
            dispatch_semaphore_signal(self.discoverThemeSemaphore);
            
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - AidNavigationHeadHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, AidTabBarHeight, 0); // 添加额外滚动区域
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 将系统的Separator左边不留间隙
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = self.carouseView;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (AidCarouselView *)carouseView
{
    if (! _carouseView) {
        _carouseView = [[AidCarouselView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidParallaxHeaderHeight)];
        _carouseView.placeholder = [UIImage imageNamed:@"backImage1.jpg"];
        _carouseView.imageArray = self.imageArray;
        _carouseView.autoMoving = YES;
        _carouseView.movingTimeInterval = 8.0;
        __weak typeof(self) weakSelf = self;
        _carouseView.didTouchPage = ^(NSInteger pageIndex) {
            [weakSelf didTouchPageIndex:pageIndex];
        };
        _carouseView.didMoveToPage = ^(NSInteger pageIndex) {
            [weakSelf didMoveToPageIndex:pageIndex];
        };
    }
    return _carouseView;
}

- (UIPageControl *)pageControl
{
    if (! _pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        CGSize pageSize = [_pageControl sizeForNumberOfPages:self.imageArray.count];
        _pageControl.frame = CGRectMake(0, 0, pageSize.width, pageSize.height);
        _pageControl.center = CGPointMake(self.carouseView.center.x, self.carouseView.height - 20);
        _pageControl.numberOfPages = self.imageArray.count; // 总页数
        _pageControl.currentPage = 0; // 当前页码
        _pageControl.hidesForSinglePage = YES; // 当总页数为1时，是否自动隐藏
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor]; // 当前点的颜色
        _pageControl.pageIndicatorTintColor = [UIColor cyanColor]; // 未被选中点的颜色
    }
    return _pageControl;
}

- (NSMutableArray<AidDiscoverThemeRecord *> *)discoverThemeArray
{
    if (! _discoverThemeArray) {
        _discoverThemeArray = [NSMutableArray array];
    }
    return _discoverThemeArray;
}

- (NSArray<UIImage *> *)imageArray
{
    return @[[UIImage imageNamed:@"backImage2.jpg"],
             [UIImage imageNamed:@"backImage4.jpg"],
             [UIImage imageNamed:@"backImage5.jpg"]];
}

@end
