//
//  LYZProjectTasksViewController.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZProjectTasksViewController.h"
#import "LYZAddTaskTableViewCell.h"
#import "LYZTaskTableViewCell.h"
#import "LYZTaskViewController.h"
#import "LYZTravelViewController.h"
#import "Masonry.h"

@interface LYZProjectTasksViewController () <UITableViewDataSource, UITableViewDelegate, LYZAddTaskTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) LYZAddTaskTableViewCell *addTaskCell;
@property (nonatomic, strong) LYZTaskTableViewCell *taskCell;
@property (nonatomic, strong) LYZTaskViewController *taskVC;
@property (nonatomic, strong) LYZTravelViewController *travelVC;


//@property (nonatomic, strong) LYZDetailViewController *detailVC;

@end


@implementation LYZProjectTasksViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarButtonItems];
    
    [self.view addSubview:self.tableView];
    
    [self layoutPageSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - life cycle helper

- (void)setBarButtonItems
{
    if (! self.tableView.isEditing) {
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
    else {
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.addTaskCell;
    }
    
    NSString * const identifier = NSStringFromClass([LYZTaskTableViewCell class]);
    LYZTaskTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[LYZTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.textLabel.text = @"北京3日游";
        }
        if (indexPath.section == 1 && indexPath.row == 1) {
            cell.textLabel.text = @"天津5日游";
        }
        else if (indexPath.section == 2 && indexPath.row == 0) {
            cell.textLabel.text = @"看小说《喜洋洋》";
        }
        else if (indexPath.section == 2 && indexPath.row == 1) {
            cell.textLabel.text = @"看《灰太狼》";
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"旅游";
    }

    if (section == 2) {
        return @"读书";
    }

    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != 0;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [self tableView:tableView titleForHeaderInSection:section];
        label.backgroundColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self.navigationController pushViewController:self.travelVC animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UIScrollViewDelegate

#pragma mark - LYZAddTaskTableViewCellDelegate

- (void)addButtonTouched:(UIButton *)button
{
    if (button == self.addTaskCell.addButton) {
        [[self navigationController] pushViewController:self.taskVC animated:YES];
    }
}

#pragma mark - event response

- (void)editButtonAction:(UIBarButtonItem *)barButton
{
    if (! [self.tableView isEditing]) {
        [self.tableView setEditing:YES animated:YES];
    }
    
    [self setBarButtonItems];
}

- (void)doneButtonAction:(UIBarButtonItem *)barButton
{
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
    }
    
    [self setBarButtonItems];
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UITableView *)tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIBarButtonItem *)editButton
{
    if (! _editButton) {
        _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
    }
    return _editButton;
}

- (UIBarButtonItem *)doneButton
{
    if (! _doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
    }
    return _doneButton;
}

- (LYZAddTaskTableViewCell *)addTaskCell
{
    if(! _addTaskCell) {
        _addTaskCell = [self.tableView dequeueReusableCellWithIdentifier:@"addTaskCell"];
        
        if(! _addTaskCell) {
            _addTaskCell = [[LYZAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addTaskCell"];
            
            _addTaskCell.backgroundColor = [UIColor lightGrayColor];
            _addTaskCell.delegate = self;
        }
    }
    return _addTaskCell;
}

- (LYZTaskViewController *)taskVC
{
    if (! _taskVC) {
        _taskVC = [[LYZTaskViewController alloc] init];
    }
    return _taskVC;
}

- (LYZTravelViewController *)travelVC
{
    if (! _travelVC) {
        _travelVC = [[LYZTravelViewController alloc] init];
    }
    return _travelVC;
}

@end
