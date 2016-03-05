//
//  AidTaskViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidTaskViewController.h"
#import "AidAddTaskViewController.h"
#import "AidEditTaskViewController.h"

#import "CTPersistance.h"

#import "AidTaskCell.h"
#import "AidOperateTaskView.h"

#import "AidTaskTable.h"

static const CGFloat AidTaskCellHeight = 70;
static const CGFloat AidDuringAnimation = 0.3;

@interface AidTaskViewController ()  <UITableViewDataSource, UITableViewDelegate, AidEditTaskViewControllerDelegate, AidOperateTaskViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AidOperateTaskView *operaterView;

@property (nonatomic, assign) BOOL displayFooter;

@property (nonatomic, strong) AidEditTaskViewController *addTaskVC;
@property (nonatomic, strong) AidEditTaskViewController *editTaskVC;

@property (nonatomic, strong) NSMutableArray<AidTaskRecord *> *taskArray;
@property (nonatomic, strong) NSIndexPath *selectPath;

@property (nonatomic, strong) dispatch_semaphore_t taskSemaphore;
@property (nonatomic, strong) dispatch_queue_t writeTaskSerilQueue;
@property (nonatomic, strong) AidTaskTable *taskTable;

@end


@implementation AidTaskViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskSemaphore = dispatch_semaphore_create(1);
        _writeTaskSerilQueue = dispatch_queue_create("com.dispatch.writeTask.AidTaskViewController", DISPATCH_QUEUE_SERIAL);
        
        self.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    }
    return self;
}

- (void)loadView
{
//    self.navigationController.navigationBarHidden = YES; // 隐藏导航条
    
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = contentView;
    
//    self.view.backgroundColor = [UIColor greenColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.operaterView];
    
    [self layoutPageSubviews];
    
    [self reloadTaskData];
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
    UIButton *button = [UIButton addButtonWithTarget:self action:@selector(addItemBarAction:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AidTaskCell *cell = [AidTaskCell cellWithTableView:tableView];
    if (self.taskArray.count != 0) {
        cell.taskRecord = self.taskArray[indexPath.row];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AidTaskRecord *taskRecord = self.taskArray[indexPath.row];
        [self deleteOneThemeRecord:taskRecord];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    [self.taskArray exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
//    [self.tableView beginUpdates];
//    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
//    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AidTaskCellHeight;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing) {
        
    }
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        self.selectPath = indexPath;
        self.editTaskVC.taskRecord = self.taskArray[indexPath.row];
        [self.navigationController pushViewController:self.editTaskVC animated:YES];
    }
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
        AidTaskRecord *taskRecord = self.taskArray[indexPath.row];
        [weakSelf deleteOneThemeRecord:taskRecord];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 收回左滑出现的按钮(退出编辑模式)
        self.tableView.editing = NO;
        
        self.selectPath = indexPath;
        self.editTaskVC.taskRecord = self.taskArray[indexPath.row];
        [self.navigationController pushViewController:self.editTaskVC animated:YES];
    }];
    editAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    editAction.backgroundColor = [UIColor grayColor];
    
    return @[deleteAction, editAction];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self footerHideAnimation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self footerDisplayAnimation];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (! decelerate) {
        [self footerDisplayAnimation];
    }
}

#pragma mark -

- (void)footerDisplayAnimation
{
    if (self.displayFooter) {
        return;
    }
    
    [UIView animateWithDuration:AidDuringAnimation animations:^(void){
        self.operaterView.frame = CGRectMake(0, [LYZDeviceInfo screenHeight] - AidTabBarHeight, [LYZDeviceInfo screenWidth], AidTabBarHeight);
    }completion:^(BOOL finished){
        self.displayFooter = YES;
    }];
}

- (void)footerHideAnimation
{
    if (! self.displayFooter) {
        return;
    }

    [UIView animateWithDuration:AidDuringAnimation animations:^(void){
        self.operaterView.frame = CGRectMake(0, [LYZDeviceInfo screenHeight], [LYZDeviceInfo screenWidth], AidTabBarHeight);
    }completion:^(BOOL finished){
        self.displayFooter = NO;
    }];
}

#pragma mark - AidEditTaskViewControllerDelegate

- (void)editTaskRecord:(AidTaskRecord *)taskRecord configureViewController:(AidEditTaskViewController *)viewController
{
    if (self.addTaskVC == viewController) {
#warning themeKey，局部刷新http://www.jianshu.com/p/97ecb0ced5e5
        taskRecord.themeID = self.themeKey;
        
        [self addOneTaskRecord:taskRecord];
    }
    else if (self.editTaskVC == viewController) {
        [self updateOneTaskRecord:taskRecord];
    }
}

#pragma mark - AidOperateTaskViewDelegate

- (void)multipleButtonTouched:(UIButton *)button withIndex:(NSInteger)index
{
    if (index == 0) {
    }
}

#pragma mark - event response

- (void)addItemBarAction:(UIBarButtonItem *)button
{
    AidTaskRecord *taskRecord = [[AidTaskRecord alloc] init];
    taskRecord.startTime = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
    taskRecord.endTime = [NSNumber numberWithDouble:[[[NSDate date] dateByAddingWeeks:1] timeIntervalSinceReferenceDate]];
    taskRecord.alarmTime = [NSNumber numberWithDouble:[[[NSDate date] dateByAddingDays:1] timeIntervalSinceReferenceDate]];
    taskRecord.repeat = @"从不";

    self.addTaskVC.taskRecord = taskRecord;
    [self.navigationController pushViewController:self.addTaskVC animated:YES];

//    AidAddTaskViewController *addTaskVC = [[AidAddTaskViewController alloc] init];
//    [self.navigationController pushViewController:addTaskVC animated:YES];
}

#pragma mark - notification response

#pragma mark - private methods

- (void)addOneTaskRecord:(AidTaskRecord *)taskRecord;
{
    dispatch_semaphore_wait(self.taskSemaphore, DISPATCH_TIME_FOREVER);
    [self.taskArray addObject:taskRecord];
    dispatch_semaphore_signal(self.taskSemaphore);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_async(self.writeTaskSerilQueue, ^{
        NSError *error = nil;
        [self.taskTable insertRecord:taskRecord error:&error];
        if ([taskRecord.primaryKey integerValue] > 0) {
            NSLog(@"1001 success");
        }
        else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    });
}

- (void)deleteOneThemeRecord:(AidTaskRecord *)taskRecord;
{
    dispatch_semaphore_wait(self.taskSemaphore, DISPATCH_TIME_FOREVER);
    [self.taskArray removeObject:taskRecord];
    dispatch_semaphore_signal(self.taskSemaphore);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_async(self.writeTaskSerilQueue, ^{
        NSError *error = nil;
        [self.taskTable deleteRecord:taskRecord error:&error];
    });
}

- (void)updateOneTaskRecord:(AidTaskRecord *)taskRecord;
{
    dispatch_semaphore_wait(self.taskSemaphore, DISPATCH_TIME_FOREVER);
    [self.taskArray replaceObjectAtIndex:self.selectPath.row withObject:taskRecord];
    dispatch_semaphore_signal(self.taskSemaphore);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[self.selectPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView reloadData];
    });
    
    dispatch_async(self.writeTaskSerilQueue, ^{
        NSError *error = nil;
        [self.taskTable updateRecord:taskRecord error:&error];
        if ([taskRecord.primaryKey integerValue] > 0) {
            NSLog(@"1001 success");
        }
        else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    });
}

- (void)reloadTaskData
{
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        NSError *error = nil;
        NSString *sqlString = @"SELECT * FROM :tableName WHERE :themeID = :themeKey;";
        NSString *tableName = [self.taskTable tableName];
        NSString *themeID = @"themeID";
        NSNumber *themeKey = self.themeKey;
        NSDictionary *params = NSDictionaryOfVariableBindings(tableName, themeID, themeKey);
        NSArray *fetchedRecordList = [self.taskTable findAllWithSQL:sqlString params:params error:&error];
        
        if ([fetchedRecordList count] > 0 && error == nil) {
            dispatch_semaphore_wait(self.taskSemaphore, DISPATCH_TIME_FOREVER);
            [self.taskArray removeAllObjects];
            [self.taskArray addObjectsFromArray:fetchedRecordList];
            dispatch_semaphore_signal(self.taskSemaphore);

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, AidNavigationHeadHeight, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - AidNavigationHeadHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, AidTabBarHeight, 0); // 添加额外滚动区域
        UIImage *bgImage = [UIImage imageNamed:@"wlbackground01.jpg"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _tableView.backgroundView = bgImageView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}

- (AidOperateTaskView *)operaterView
{
    if (! _operaterView) {
        NSArray<NSString *> *titleNames = @[@"分享", @"评论", @"更多"];
        NSArray<NSString *> *imageNames = @[@"icon_share_default", @"icon_news_default", @"icon_more_default"];
        
        _operaterView = [[AidOperateTaskView alloc] initWithFrame:CGRectMake(0, [LYZDeviceInfo screenHeight] - AidTabBarHeight, [LYZDeviceInfo screenWidth], AidTabBarHeight) titleNames:titleNames imageNames:imageNames];
        _operaterView.backgroundColor =  LYZColorRGB(239/255.0, 239/255.0, 244/255.0);
        _operaterView.delegate = self;
    }
    return _operaterView;
}

- (AidEditTaskViewController *)addTaskVC
{
    if (! _addTaskVC) {
        _addTaskVC = [[AidEditTaskViewController alloc] init];
        _addTaskVC.delegate = self;
    }
    return _addTaskVC;
}

- (AidEditTaskViewController *)editTaskVC
{
    if (! _editTaskVC) {
        _editTaskVC = [[AidEditTaskViewController alloc] init];
        _editTaskVC.delegate = self;
    }
    return _editTaskVC;
}

- (NSMutableArray<AidTaskRecord *> *)taskArray
{
    if (! _taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (AidTaskTable *)taskTable
{
    if (! _taskTable) {
        _taskTable = [[AidTaskTable alloc] init];
    }
    return _taskTable;
}

@end
