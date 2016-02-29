//
//  AidThemeViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/9/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "AidThemeViewController.h"
#import "AidAddThemeViewController.h"
#import "AidTaskViewController.h"

#import "AidMultipleButtonView.h"
#import "AidThemeCell.h"

#import "AidThemeTable.h"
#import "AidTaskTable.h"

#import "AidNetwork.h"

static const CGFloat AidThemeCellHeight = 110;

@interface AidThemeViewController () <UITableViewDataSource, UITableViewDelegate, AidAddThemeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<AidThemeRecord *> *themeArray;
@property (nonatomic, strong) NSIndexPath *selectPath;

@property (nonatomic, strong) dispatch_semaphore_t themeSemaphore;
@property (nonatomic, strong) dispatch_queue_t writeThemeSerilQueue;
@property (nonatomic, strong) dispatch_queue_t writeTaskSerilQueue;
@property (nonatomic, strong) AidThemeTable *themeTable;
@property (nonatomic, strong) AidTaskTable *taskTable;

@end


@implementation AidThemeViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _themeSemaphore = dispatch_semaphore_create(1);
        _writeThemeSerilQueue = dispatch_queue_create("com.dispatch.writeTheme.AidThemeViewController", DISPATCH_QUEUE_SERIAL);
        _writeTaskSerilQueue = dispatch_queue_create("com.dispatch.writeTask.AidThemeViewController", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = contentView;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
//    [self addOne];
    
    [self.view addSubview:self.tableView];
    
    [self layoutPageSubviews];
    
    [self setupRefreshHead];
    
    [self reloadThemeRecord];
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
    NSArray *array = @[@"自建", @"收藏"];
    AidMultipleButtonView *buttonView = [[AidMultipleButtonView alloc]initWithFrame:CGRectMake(0, 0, 160, 40) titleArray:array];
    __weak typeof(self) weakSelf = self;
    buttonView.buttonTouched = ^(NSInteger index) {
        [weakSelf multipleButtonTouchedAtIndex:index];
    };
    self.navigationItem.titleView = buttonView;
    
    UIButton *button = [UIButton shareButtonWithTarget:self action:@selector(addItemBarAction:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)addOne
{
#warning 测试UISegmentedControl，未使用
    NSArray *array = @[@"自建", @"收藏"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.momentary = NO; // 设置在点击后是否恢复原样
    segment.multipleTouchEnabled = NO;
    segment.frame = CGRectMake(0, 0, 160, 40);
    segment.selectedSegmentIndex = 1;
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}

- (void)segmentAction:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            break;
            
        default:
            break;
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
    }];
}

- (void)setupRefreshHead
{
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
//    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
//    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
//    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    self.tableView.mj_header = header;
    
    [self.tableView.mj_header beginRefreshing];
    
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//
//    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
//    [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
//    
//    footer.stateLabel.font = [UIFont systemFontOfSize:17];
//    
//    footer.stateLabel.textColor = [UIColor blueColor];
//    
//    self.tableView.mj_footer = footer;
}

- (void)reloadThemeRecord
{
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        NSError *error = nil;
        NSString *whereCondition = @":primaryKey > 0";
        NSString *primaryKey = [self.themeTable primaryKeyName];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKey);
        NSArray *fetchedRecordList = [self.themeTable findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
        
        if (fetchedRecordList.count > 0 && error == nil) {
            dispatch_semaphore_wait(self.themeSemaphore, DISPATCH_TIME_FOREVER);
            [self.themeArray removeAllObjects];
            [self.themeArray addObjectsFromArray:fetchedRecordList];
            dispatch_semaphore_signal(self.themeSemaphore);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.themeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidThemeCell *cell = [AidThemeCell cellWithTableView:tableView];
    
    if (self.themeArray.count != 0) {
        cell.themeRecord = self.themeArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AidThemeRecord *themeRecord = self.themeArray[indexPath.row];
        [self deleteOneThemeRecord:themeRecord];
    }
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
    self.selectPath = indexPath;

    AidTaskViewController *themeVC = [[AidTaskViewController alloc] init];
    AidThemeRecord *record = self.themeArray[indexPath.row];
    themeVC.themeKey = record.primaryKey;

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:themeVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AidThemeRecord *themeRecord = self.themeArray[indexPath.row];
        [weakSelf deleteOneThemeRecord:themeRecord];
    }];
    
    return @[deleteAction];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

#pragma mark - UIScrollViewDelegate

#pragma mark - AidAddThemeViewControllerDelegate

- (void)addThemeRecord:(AidThemeRecord *)themeRecord;
{
    [self addOneThemeRecord:themeRecord];
}

#pragma mark - event response

- (void)multipleButtonTouchedAtIndex:(NSInteger)index
{
    if (index == 0) {
        self.tableView.hidden = NO;
    }
    else {
        self.tableView.hidden = YES;
    }
}

- (void)addItemBarAction:(UIBarButtonItem *)button
{
    AidAddThemeViewController *addThemeVC = [[AidAddThemeViewController alloc] init];
    addThemeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical; // 弹出动画风格
    addThemeVC.modalPresentationStyle = UIModalPresentationFormSheet; // 弹出风格
    addThemeVC.delegate = self;
    
    [self presentViewController:addThemeVC animated:YES completion:nil];
}


- (void)refreshData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // 刷新主题数据
        [self refreshThemeData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 这个里面是主线程要做的事  可以刷新UI
        });
    });
}

-(void)refreshTest
{
    NSString *baseUrl = @"http://125.89.65.238:8821/ics.cgi";
    NSDictionary *params = @{@"age": @"txt_age",
                             @"username": @"txt_username"};
//    NSString *urlStr = [baseUrl URLQueryStringAppendDictionary:params];
//    [AidNetWork getWithUrl:urlStr success:^(id response) {
//        LYZPRINT(@"%@", response);
//    } failure:^(NSError *error) {
//        LYZPRINT(@"%@", error);
//    }];
    
    [AidNetwork getWithUrl:baseUrl params:params success:^(id response) {
        LYZPRINT(@"%@", response);
    } failure:^(NSError *error) {
        LYZPRINT(@"%@", error);
    }];
}

- (void)refreshThemeData
{
    // 模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - notification response

#pragma mark - private methods

- (void)addOneThemeRecord:(AidThemeRecord *)themeRecord;
{
    dispatch_semaphore_wait(self.themeSemaphore, DISPATCH_TIME_FOREVER);
    [self.themeArray addObject:themeRecord];
    dispatch_semaphore_signal(self.themeSemaphore);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_async(self.writeThemeSerilQueue, ^{
        NSError *error = nil;
        [self.themeTable insertRecord:themeRecord error:&error];
        if ([themeRecord.primaryKey integerValue] > 0) {
            NSLog(@"1001 success");
        }
        else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    });
}

- (void)deleteOneThemeRecord:(AidThemeRecord *)themeRecord;
{
    NSNumber *primaryKey = [themeRecord.primaryKey copy];
    
    dispatch_semaphore_wait(self.themeSemaphore, DISPATCH_TIME_FOREVER);
    [self.themeArray removeObject:themeRecord];
    dispatch_semaphore_signal(self.themeSemaphore);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_async(self.writeThemeSerilQueue, ^{
        NSError *error = nil;
        [self.themeTable deleteRecord:themeRecord error:&error];
        
//        dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(currentQueue, ^{
//            NSError *error = nil;
//            AidThemeRecord *themeRecord = (AidThemeRecord *)[self.themeTable findWithPrimaryKey:primaryKey error:&error];
//            if (themeRecord) {
//                NSException *exception = [[NSException alloc] init];
//                @throw exception;
//            } else {
//                NSLog(@"4001 success");
//            }
//        });
    });
    
//    [self deleteAllTaskRecordByThemePrimaryKey:primaryKey];
}

- (void)deleteAllTaskRecordByThemePrimaryKey:(NSNumber *)themePrimaryKey;
{
    dispatch_async(self.writeTaskSerilQueue, ^{
        NSError *error = nil;
        NSString *sqlString = @"DELETE FROM :tableName WHERE :themeID = :themeKey;";
        NSString *tableName = [self.taskTable tableName];
        NSString *themeID = @"themeID";
        NSNumber *themeKey = themePrimaryKey;
        NSDictionary *params = NSDictionaryOfVariableBindings(tableName, themeID, themeKey);
        [self.taskTable deleteWithSql:sqlString params:params error:&error];
        
//        dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(currentQueue, ^{
//            NSError *error = nil;
//            NSString *sqlString = @"SELECT COUNT(*) AS count FROM :tableName WHERE :themeID = :themeKey;";
//            NSDictionary *fetchedRecordDictionay = [self.taskTable countWithSQL:sqlString params:params error:&error];
//            NSNumber *count = (NSNumber *)[fetchedRecordDictionay objectForKey:@"count"];
//            if ( count.intValue > 0) {
//                NSException *exception = [[NSException alloc] init];
//                @throw exception;
//            } else {
//                NSLog(@"4002 success");
//            }
//        });
    });
}

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];

        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray<AidThemeRecord *> *)themeArray
{
    if (! _themeArray) {
        _themeArray = [NSMutableArray array];
    }
    return _themeArray;
}

- (AidThemeTable *)themeTable
{
    if (! _themeTable) {
        _themeTable = [[AidThemeTable alloc] init];
    }
    return _themeTable;
}

- (AidTaskTable *)taskTable
{
    if (! _taskTable) {
        _taskTable = [[AidTaskTable alloc] init];
    }
    return _taskTable;
}

@end
