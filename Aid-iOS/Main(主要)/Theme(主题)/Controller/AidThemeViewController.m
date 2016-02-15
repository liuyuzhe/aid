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
#import "MGSwipeButton.h"

#import "AidThemeTable.h"

#import "AidNetWork.h"

static const CGFloat AidTableViewRowAnimationDuration = 0.25;
static const CGFloat AidThemeCellHeight = 110;

@interface AidThemeViewController () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, AidAddThemeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<AidThemeRecord *> *themeArray;
@property (nonatomic, strong) NSIndexPath *selectPath;  // 当前选择的行

@property (nonatomic, strong) dispatch_semaphore_t themeSemaphore;
@property (nonatomic, strong) dispatch_queue_t writeThemeSerilQueue;
@property (nonatomic, strong) AidThemeTable *themeTable;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress; /**< 长按手势 */
@property (nonatomic, strong) UIView *snapshot; /**< Cell截图 */
@property (nonatomic, strong) NSIndexPath *sourceIndexPath; /**< 目标Cell */
@property (nonatomic, strong) UIColor *originBackgroundColor; /**< Cell初始背景 */
@property (nonatomic, assign) CGFloat scrollRate; /**< 滚动速率 */
@property (nonatomic, strong) CADisplayLink *scrollDisplayLink; /**< cell滚动时，刷新TableView */

@end


@implementation AidThemeViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _themeSemaphore = dispatch_semaphore_create(1);
        _writeThemeSerilQueue = dispatch_queue_create("com.dispatch.writeTheme", DISPATCH_QUEUE_SERIAL);
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
    
    [self.view addSubview:self.tableView];
    
    [self layoutPageSubviews];
    
    [self setupRefreshHead];
    
    [self loadThemeData];
    
    [self addPressGesture];
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
    
    UIBarButtonItem *addItem = [UIBarButtonItem initWithNormalImage:@"icon_homepage_search" target:self action:@selector(addItemBarAction:) width:24 height:24];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)addOne
{
#warning 测试UISegmentedControl，未使用
    NSArray *array = @[@"自建", @"收藏"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.momentary = YES; // 设置在点击后是否恢复原样
    segment.multipleTouchEnabled = NO;
    segment.frame = CGRectMake(0, 0, 160, 40);
    segment.selectedSegmentIndex = 1;
    segment.tintColor = [UIColor greenColor];
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

- (void)addPressGesture
{
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    [self.tableView addGestureRecognizer:_longPress];
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
//    cell.delegate = self;
    
    if (self.themeArray.count != 0) {
        cell.themeRecord = self.themeArray[indexPath.row];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.themeArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        if (self.themeArray.count == 0) {
//            [tableView reloadData];
//        }
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        AidThemeRecord *record = [[AidThemeRecord alloc] init];
//        
//        [self.themeArray insertObject:record atIndex:indexPath.row];
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    NSUInteger fromRow = [sourceIndexPath row];
//    NSUInteger toRow = [destinationIndexPath row];
//    
//    [self.themeArray exchangeObjectAtIndex:fromRow withObjectAtIndex:toRow];
//}

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

    [self.navigationController pushViewController:themeVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 10)];
    headerView.backgroundColor =  LYZColorRGB(239/255.0, 239/255.0, 244/255.0);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], 0)];
    footerView.backgroundColor =  LYZColorRGB(239/255.0, 239/255.0, 244/255.0);
    return footerView;
}

#pragma mark - UIScrollViewDelegate

#pragma mark - AidAddThemeViewControllerDelegate

- (void)addThemeRecord:(AidThemeRecord *)themeRecord;
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
    
#warning insertRowsAtIndexPaths 效率及闪退问题
//    [self.tableView beginUpdates];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.themeArray.count inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
}

#pragma mark - MGSwipeTableCellDelegate

//- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction
//{
//    return YES;
//}
//
//- (void)swipeTableCell:(MGSwipeTableCell*)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
//{
//    
//}
//
//- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
//{
//    LYZINFO(@"Delegate: button tapped, %@ position, index %zd, from Expansion: %@", direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", index, fromExpansion ? @"YES" : @"NO");
//
//    if (direction == MGSwipeDirectionRightToLeft) {
//        if (index == 0) {
//            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//            [self.themeArray removeObjectAtIndex:indexPath.row];
//            [self.tableView beginUpdates];
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            [self.tableView endUpdates];
//            return NO;
//        }
//        else if (index == 1) {
//            return NO;
//        }
//    }
//
//    return YES;
//}
//
//- (NSArray *)swipeTableCell:(MGSwipeTableCell*)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings*)swipeSettings expansionSettings:(MGSwipeExpansionSettings*)expansionSettings
//{
//    swipeSettings.transition = MGSwipeTransitionDrag;
//    expansionSettings.fillOnTrigger = NO;
//    
//    if (direction == MGSwipeDirectionRightToLeft) {
//        return [self createRightButtons];
//    }
//    
//    return nil;
//}
//
//#pragma mark - 
//
//- (NSArray<__kindof UIButton *> *)createRightButtons
//{
//    NSMutableArray * result = [NSMutableArray array];
//    NSString* titles[2] = {@"删除", @"设置"};
//    UIColor * colors[2] = {[UIColor redColor], [UIColor grayColor]};
//    for (int i = 0; i < 2; ++i)
//    {
//        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] padding:15];
//        [result addObject:button];
//    }
//    return [result copy];
//}

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
    
    [AidNetWork getWithUrl:baseUrl params:params success:^(id response) {
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

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    UIGestureRecognizerState state = gesture.state;
    
    switch (state)
    {
        case UIGestureRecognizerStateBegan:
            [self didBeginLongPressGestureRecognizer:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self didChangeLongPressGestureRecognizer:gesture];
            break;
        case UIGestureRecognizerStateEnded:
            [self didEndLongPressGestureRecognizer:gesture];
        default:
            break;
    }
}

/** 伴随着Cell移动，滚动TableView */
- (void)scrollTableWithCell:(CADisplayLink *)timer
{
    UILongPressGestureRecognizer *gesture = self.longPress;
    const CGPoint location = [gesture locationInView:self.tableView];
    
    CGPoint currentOffset = self.tableView.contentOffset;
    CGPoint newOffset = CGPointMake(currentOffset.x, currentOffset.y + self.scrollRate * 5);
    
    // 计算tableView偏移
    if (newOffset.y < -self.tableView.contentInset.top) {
        newOffset.y = -self.tableView.contentInset.top;
    }
    else if (self.tableView.contentSize.height + self.tableView.contentInset.bottom < self.view.height) {
        newOffset = currentOffset;
    }
    else if (newOffset.y > (self.tableView.contentSize.height + self.tableView.contentInset.bottom) - self.view.height) {
        newOffset.y = (self.tableView.contentSize.height + self.tableView.contentInset.bottom) - self.view.height;
    }
    
    [self.tableView setContentOffset:newOffset];
    
    if (location.y >= 0 && location.y <= self.tableView.contentSize.height + 50) {
        self.snapshot.center = CGPointMake(self.view.center.x, location.y);
    }
    
    [self updateCurrentLocation:gesture];
}

#pragma mark -

- (void)didBeginLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    // 判断长按是否在Cel上
    if (! indexPath) {
        gesture.enabled = NO;
        gesture.enabled = YES;
        return;
    }
    
    _sourceIndexPath = indexPath;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // 设置Cell的背景色
    _originBackgroundColor = cell.backgroundColor;
    cell.backgroundColor = [UIColor orangeColor];
    
    // 截图并添加阴影
    UIImage *snapshotImage = [cell snapshotImage];
    _snapshot = [[UIImageView alloc] initWithImage:snapshotImage];
    [_snapshot setShadow];
    
    _snapshot.center = cell.center;
    _snapshot.alpha = 1.0;
    [self.tableView addSubview:_snapshot];
    
    [UIView animateWithDuration:AidTableViewRowAnimationDuration animations:^{
        self.snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
        self.snapshot.alpha = 0.98;
        cell.alpha = 1.0;
    } completion:^(BOOL finished) {
        cell.backgroundColor = [self.originBackgroundColor colorWithAlphaComponent:0.6];
        cell.alpha = 0.0;
        cell.hidden = YES;
    }];
    
    _scrollDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableWithCell:)];
    [_scrollDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)didChangeLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    
    if (location.y >= 0 && location.y <= self.tableView.contentSize.height + 50)
    {
        _snapshot.center = CGPointMake(self.tableView.center.x, location.y);
    }
    
    CGRect rect = self.view.bounds;
    rect.size.height -= self.tableView.contentInset.top;

    [self updateCurrentLocation:gesture];
    
    // 计算滚动条件
    CGFloat scrollZoneHeight = rect.size.height / 6;
    CGFloat bottomScrollBeginning = self.tableView.contentOffset.y + self.tableView.contentInset.top + rect.size.height - scrollZoneHeight;
    CGFloat topScrollBeginning = self.tableView.contentOffset.y + self.tableView.contentInset.top  + scrollZoneHeight;
    
    if (location.y >= bottomScrollBeginning) {
        _scrollRate = (location.y - bottomScrollBeginning) / scrollZoneHeight;
    }
    else if (location.y <= topScrollBeginning) {
        _scrollRate = (location.y - topScrollBeginning) / scrollZoneHeight;
    }
    else {
        _scrollRate = 0;
    }
}

- (void)didEndLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.sourceIndexPath];
    cell.hidden = NO;
    cell.alpha = 0.0;

    [_scrollDisplayLink invalidate];
    _scrollDisplayLink = nil;

    [UIView animateWithDuration:AidTableViewRowAnimationDuration animations:^{
        _snapshot.transform = CGAffineTransformIdentity;
        _snapshot.alpha = 0.0;
        cell.alpha = 1.0;
    } completion:^(BOOL finished) {
        _scrollRate = 0;
        _sourceIndexPath = nil;
        [_snapshot removeFromSuperview];
        _snapshot = nil;
    }];
}

- (void)updateCurrentLocation:(UILongPressGestureRecognizer *)gesture
{
    const CGPoint location  = [gesture locationInView:self.tableView];
    NSIndexPath *toIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if ([toIndexPath compare:self.sourceIndexPath] == NSOrderedSame) {
        return;
    }
    
    // 交换Cell
    [self.themeArray exchangeObjectAtIndex:toIndexPath.row withObjectAtIndex:self.sourceIndexPath.row];
    [self.tableView beginUpdates];
    [self.tableView moveRowAtIndexPath:self.sourceIndexPath toIndexPath:toIndexPath];
    self.sourceIndexPath = toIndexPath;
    [self.tableView endUpdates];
    //TODO: 数据库排序
}

#pragma mark - notification response

#pragma mark - private methods

- (void)loadThemeData
{
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        NSError *error = nil;
        NSString *whereCondition = @":primaryKey > 0";
        NSString *primaryKey = [self.themeTable primaryKeyName];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKey);
        NSArray *fetchedRecordList = [self.themeTable findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
        
        if (fetchedRecordList.count > 0 && error == nil) {
            [self.themeArray removeAllObjects];
            [self.themeArray addObjectsFromArray:fetchedRecordList];
            
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
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

@end
