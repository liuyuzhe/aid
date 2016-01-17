//
//  AidChildDetailViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/10.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidChildDetailViewController.h"

#import "AidCarouselView.h"
#import "AidHotDetailCell.h"

#import "AidHotDetailTable.h"

#import "UINavigationBar+Awesome.h"
#import "UIView+LYZMasonyCategory.h"

static const CGFloat AidParallaxHeaderHeight = 235;
static const CGFloat AidNavbarChangePoint = 50;

@interface AidChildDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UIImageView *parallaxHeaderView;
@property (nonatomic, strong) AidCarouselView *carouseView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray<AidHotDetailTable *> *hotDetailArray;
@property (nonatomic, strong) NSArray<UIImage *> *imageArray;

@end


@implementation AidChildDetailViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    //    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.pageControl];
    
    [self layoutPageSubviews];
    
    [self loadThemeData];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.carouseView startMoving];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.carouseView stopMoving];
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
    AidHotDetailCell *cell = [AidHotDetailCell cellWithTableView:tableView];
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
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > AidNavbarChangePoint) {
        CGFloat alpha = MIN(1, 1 - ((AidNavbarChangePoint + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - event response

- (void)searchBarAction:(UIButton *)button
{
}

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight]) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 将系统的Separator左边不留间隙
        _tableView.separatorInset = UIEdgeInsetsZero;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, AidParallaxHeaderHeight)];
        imageView.image = [UIImage imageNamed:@"bg.jpg"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
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

- (NSMutableArray<AidHotDetailTable *> *)hotDetailArray
{
    if (! _hotDetailArray) {
        _hotDetailArray = [NSMutableArray array];
    }
    return _hotDetailArray;
}

- (NSArray<UIImage *> *)imageArray
{
    return @[[UIImage imageNamed:@"backImage2.jpg"],
             [UIImage imageNamed:@"backImage4.jpg"],
             [UIImage imageNamed:@"backImage5.jpg"]];
}

@end
