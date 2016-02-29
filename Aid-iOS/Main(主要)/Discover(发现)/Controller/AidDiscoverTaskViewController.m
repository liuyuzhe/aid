//
//  AidDiscoverTaskViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverTaskViewController.h"

#import "AidDiscoverTaskCell.h"
#import "AidCarouselView.h"
#import "AidDiscoverThemeShowView.h"
#import "AidFlagControl.h"
#import "AidOperateTaskView.h"

#import "AidDiscoverTaskTable.h"
#import "AidDiscoverThemeRecord.h"

#import "UINavigationBar+Awesome.h"
#import "UIView+LYZMasonyCategory.h"

static const CGFloat AidHeadViewHeigtht = 235;
static const CGFloat AidThemeShowViewHeigtht = 50;
static const CGFloat AidNavbarChangePoint = 50;
static const CGFloat AidThemeCellHeight = 70;

@interface AidDiscoverTaskViewController () <UITableViewDataSource, UITableViewDelegate, AidOperateTaskViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) AidDiscoverThemeShowView *themeShowView;
@property (nonatomic, strong) AidFlagControl *praiseControl; /**< 是否点赞 */
@property (nonatomic, strong) AidOperateTaskView *operaterView;

@property (nonatomic, strong) NSMutableArray<AidDiscoverTaskRecord *> *discoverTaskArray;

@property (nonatomic, strong) dispatch_semaphore_t discoverTaskSemaphore;
@property (nonatomic, strong) dispatch_queue_t writeDiscoverTaskSerilQueue;
@property (nonatomic, strong) AidDiscoverTaskTable *discoverTaskTable;

@property (nonatomic, strong) NSNumber *themeKey;

@end


@implementation AidDiscoverTaskViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _discoverTaskSemaphore = dispatch_semaphore_create(1);
        _writeDiscoverTaskSerilQueue = dispatch_queue_create("com.dispatch.writeDiscoverTask.AidDiscoverTaskViewController", DISPATCH_QUEUE_SERIAL);

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
    [self.view addSubview:self.operaterView];
    [self.headView addSubview:self.headImageView];
    [self.headView addSubview:self.themeShowView];
    
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
#warning button frame
    UIButton *button = [UIButton shareButtonWithTarget:self action:@selector(addItemBarAction:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *praiseItem = [[UIBarButtonItem alloc] initWithCustomView:self.praiseControl];

    self.navigationItem.rightBarButtonItems = @[addItem, praiseItem];
    
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
    return self.discoverTaskArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidDiscoverTaskCell *cell = [AidDiscoverTaskCell cellWithTableView:tableView];
    if (self.discoverTaskArray.count != 0) {
        cell.discoverTaskRecord = self.discoverTaskArray[indexPath.row];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AidThemeCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }

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
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
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

#pragma mark - AidOperateTaskViewDelegate

- (void)multipleButtonTouched:(UIButton *)button withIndex:(NSInteger)index
{
    if (index == 0) {
    }
}

#pragma mark - event response

- (void)addItemBarAction:(UIButton *)button
{
    for (int i = 0; i < 1; ++i) {
        AidDiscoverTaskRecord *taskRecord = [[AidDiscoverTaskRecord alloc] init];
        taskRecord.name = [NSString stringWithFormat:@"跟着我左手右手一个慢动作，右手%d", i];
        taskRecord.startTime = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
        taskRecord.endTime = [NSNumber numberWithDouble:[[[NSDate date] dateByAddingWeeks:1] timeIntervalSinceReferenceDate]];
        taskRecord.alarmTime = [NSNumber numberWithDouble:[[[NSDate date] dateByAddingDays:1] timeIntervalSinceReferenceDate]];
        taskRecord.repeat = @"从不";
        taskRecord.themeID = self.themeKey;
        
        [self addOneThemeRecord:taskRecord];
    }
}

- (void)praiseControlAction:(AidFlagControl *)control
{
    if (control.currentFlag == AidFlagControlStateNO) {
        [control setFlag:AidFlagControlStateYES withAnimation:YES];
    }
    else if (control.currentFlag == AidFlagControlStateYES) {
        [control setFlag:AidFlagControlStateNO withAnimation:YES];
    }
}

#pragma mark - notification response

#pragma mark - private methods

- (void)addOneThemeRecord:(AidDiscoverTaskRecord *)taskRecord;
{
    dispatch_semaphore_wait(self.discoverTaskSemaphore, DISPATCH_TIME_FOREVER);
    [self.discoverTaskArray addObject:taskRecord];
    dispatch_semaphore_signal(self.discoverTaskSemaphore);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_async(self.writeDiscoverTaskSerilQueue, ^{
        NSError *error = nil;
        [self.discoverTaskTable insertRecord:taskRecord error:&error];
        if (taskRecord.primaryKey) {
            NSLog(@"1001 success");
        }
        else {
            LYZERROR(@"%@", error.localizedDescription);
        }
    });
}

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
            dispatch_semaphore_wait(self.discoverTaskSemaphore, DISPATCH_TIME_FOREVER);
            [self.discoverTaskArray removeAllObjects];
            [self.discoverTaskArray addObjectsFromArray:fetchedRecordList];
            dispatch_semaphore_signal(self.discoverTaskSemaphore);
            
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
        UIImage *bgImage = [UIImage imageNamed:@"wlbackground09.jpg"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _tableView.backgroundView = bgImageView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;

        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIView *)headView
{
    if (! _headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidHeadViewHeigtht)];
    }
    return _headView;
}

- (UIImageView *)headImageView
{
    if (! _headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidHeadViewHeigtht)];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"backImage1.jpg"];
    }
    return _headImageView;
}

- (AidDiscoverThemeShowView *)themeShowView
{
    if (! _themeShowView) {
        _themeShowView = [[AidDiscoverThemeShowView alloc] initWithFrame:CGRectMake(0, AidHeadViewHeigtht - AidThemeShowViewHeigtht, [LYZDeviceInfo screenWidth], AidThemeShowViewHeigtht)];
    }
    return _themeShowView;
}

- (AidFlagControl *)praiseControl
{
    if (! _praiseControl) {
        _praiseControl = [[AidFlagControl alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
        _praiseControl.noStateImage = [UIImage imageNamed:@"love"];
        _praiseControl.yesStateImage = [UIImage imageNamed:@"love_oc"];
        [_praiseControl addTarget:self action:@selector(praiseControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseControl;
}

- (AidOperateTaskView *)operaterView
{
    if (! _operaterView) {
        NSArray<NSString *> *titleNames = @[@"分享", @"评论", @"点赞", @"收藏"];
        NSArray<NSString *> *imageNames = @[@"searchList_btn_delete_6P", @"searchList_btn_delete_6P", @"searchList_btn_delete_6P", @"searchList_btn_delete_6P"];
        
        _operaterView = [[AidOperateTaskView alloc] initWithFrame:CGRectMake(0, self.tableView.height - AidTabBarHeight, [LYZDeviceInfo screenWidth], AidTabBarHeight) titleNames:titleNames imageNames:imageNames];
        _operaterView.backgroundColor =  LYZColorRGB(239/255.0, 239/255.0, 244/255.0);
        _operaterView.delegate = self;
    }
    return _operaterView;
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

- (void)setThemeRecord:(AidDiscoverThemeRecord *)themeRecord
{
    _themeRecord = themeRecord;
    
    self.themeKey = themeRecord.primaryKey;
    
    self.themeShowView.discoverThemeRecord = themeRecord;
}

@end
