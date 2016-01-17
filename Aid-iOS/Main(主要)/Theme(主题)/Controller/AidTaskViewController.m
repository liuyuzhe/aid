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

#import "AidTaskCell.h"
#import "MGSwipeButton.h"
#import "AidOperateTaskView.h"

#import "AidTaskTable.h"

@interface AidTaskViewController ()  <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AidOperateTaskView *operaterView;

@property (nonatomic, strong) NSMutableArray<AidTaskRecord *> *taskArray;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectIndexPaths; // 存放多选行的可变数组
@property (nonatomic, strong) NSIndexPath *selectPath;  // 当前选择的行

@end


@implementation AidTaskViewController

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
//    self.navigationController.navigationBarHidden = YES; // 隐藏导航条
    
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = contentView;
    
//    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.operaterView];
    
    [self layoutPageSubviews];
    
    [self loadTaskData];
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
    UIBarButtonItem *addItem = [UIBarButtonItem initWithNormalImage:@"icon_homepage_search" target:self action:@selector(addItemBarAction:) width:24 height:24];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.bottom.equalTo(self.operaterView);
    }];
    
    [self.operaterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf);
        make.height.equalTo(@49);
    }];
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
//    cell.delegate = self;
    if (self.taskArray.count != 0) {
        cell.taskRecord = self.taskArray[indexPath.row];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskArray removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        if (self.taskArray.count == 0) {
            [tableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.taskArray exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
    [self.tableView beginUpdates];
    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing) {
        if ([self.selectIndexPaths containsObject:indexPath]) {
            [self.selectIndexPaths removeObject:indexPath];
        }
        else {
            [self.selectIndexPaths addObject:indexPath];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        AidEditTaskViewController *editTaskVC = [[AidEditTaskViewController alloc] init];
        [self.navigationController pushViewController:editTaskVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - UIScrollViewDelegate

#pragma mark - MGSwipeTableCellDelegate
//
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
//- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell
//   tappedButtonAtIndex:(NSInteger)index
//             direction:(MGSwipeDirection)direction
//         fromExpansion:(BOOL)fromExpansion
//{
//    LYZINFO(@"Delegate: button tapped, %@ position, index %zd, from Expansion: %@", direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", index, fromExpansion ? @"YES" : @"NO");
//    
//    if (direction == MGSwipeDirectionRightToLeft) {
//        if (index == 0) {
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
//- (NSArray *)swipeTableCell:(MGSwipeTableCell*)cell
//   swipeButtonsForDirection:(MGSwipeDirection)direction
//              swipeSettings:(MGSwipeSettings*)swipeSettings
//          expansionSettings:(MGSwipeExpansionSettings*)expansionSettings
//{
//    swipeSettings.transition = MGSwipeTransitionDrag;
//    
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
//    NSString* titles[2] = {@"删除", @"编辑"};
//    UIColor * colors[2] = {[UIColor redColor], [UIColor grayColor]};
//    for (int i = 0; i < 2; ++i)
//    {
//        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] padding:15];
//        [result addObject:button];
//    }
//    return [result copy];
//}

#pragma mark - event response

- (void)addItemBarAction:(UIBarButtonItem *)button
{
    AidAddTaskViewController *addTaskVC = [[AidAddTaskViewController alloc] init];
    [self.navigationController pushViewController:addTaskVC animated:YES];
}

- (void)multipleButtonTouchedAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self editButtonAction];
    }
}

- (void)editButtonAction
{
    if (! self.tableView.isEditing) {
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.tableView setEditing:YES animated:YES];
    }
    else {
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - notification response

#pragma mark - private methods

- (void)loadTaskData
{
    AidTaskTable *table = [[AidTaskTable alloc] init];
    NSError *error = nil;
    
    NSString *whereCondition = @":primaryKey > 0";
    NSString *primaryKey = [table primaryKeyName];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKey);
    NSArray *fetchedRecordList = [table findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if ([fetchedRecordList count] > 0 && error == nil) {
        NSLog(@"2001 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    [self.taskArray removeAllObjects];
    [self.taskArray addObjectsFromArray:fetchedRecordList];
    [self.tableView reloadData];
}

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - AidNavHeadHeigtht) style:UITableViewStylePlain];
        
        UIImage *bgImage = [UIImage imageNamed:@"wlbackground01.jpg"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
//        bgImageView.frame = _tableView.frame;
        _tableView.backgroundView = bgImageView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor clearColor];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}

- (AidOperateTaskView *)operaterView
{
    if (! _operaterView) {
        NSArray<NSString *> *imageNames = @[@"about_criticism", @"about_criticism", @"about_criticism", @"about_criticism"];
        NSArray<NSString *> *titleNames = @[@"编辑", @"排序", @"分享", @"更多"];
        
        _operaterView = [[AidOperateTaskView alloc] initWithFrame:CGRectMake(0, 0, [LYZDeviceInfo screenWidth], AidTabBarHeight)imageNames:imageNames titleNames:titleNames];
        _operaterView.backgroundColor =  LYZColorRGB(239/255.0, 239/255.0, 244/255.0);
        __weak typeof(self) weakSelf = self;
        _operaterView.buttonTouched = ^(NSInteger index) {
            [weakSelf multipleButtonTouchedAtIndex:index];
        };
    }
    return _operaterView;
}

- (NSMutableArray<AidTaskRecord *> *)taskArray
{
    if (! _taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (NSMutableArray<NSIndexPath *> *)selectIndexPaths
{
    if (! _selectIndexPaths) {
        _selectIndexPaths = [NSMutableArray array];
    }
    return _selectIndexPaths;
}

@end
