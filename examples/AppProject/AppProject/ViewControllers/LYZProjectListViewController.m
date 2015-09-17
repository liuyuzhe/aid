//
//  LYZProjectListViewController.m
//  AppProject
//
//  Created by 刘育哲 on 15/6/23.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZProjectListViewController.h"
#import "LYZAddListTableViewCell.h"
#import "LYZProjectTasksViewController.h"
#import "Masonry.h"

@interface LYZProjectListViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) LYZAddListTableViewCell *addListCell;

@property (nonatomic, strong) NSMutableArray *projectList;

@property (nonatomic, strong) LYZProjectTasksViewController *tasksVC;

@end


@implementation LYZProjectListViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    
    self.title = @"项目";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectList = [@[@"最健康的作息", @"放松之旅", @"每天进步一点点"] mutableCopy];
    
    self.tasksVC = [[LYZProjectTasksViewController alloc] init];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
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
    
    return self.projectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.addListCell;
    }
    
    NSString * const identifier = NSStringFromClass([UITableViewCell class]);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = self.projectList[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self navigationController] pushViewController:self.tasksVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self hideKeyBoard];
//}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.addListCell.textField) {
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.addListCell.textField) {
        [self addNewItem];
    }
    
    return YES;
}

#pragma mark - event response

- (void)searchAction:(UIBarButtonItem *)barButton
{
}

- (void)hideKeyBoard
{
    [self.addListCell.textField resignFirstResponder];
}

#pragma mark - notification response

#pragma mark - private methods

- (void)addNewItem
{
    if(self.addListCell.textField.text.length <= 0) {
        [self hideKeyBoard];
        return;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.addListCell.textField.text;
    // TODO:
    [self hideKeyBoard];
}

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

- (UIBarButtonItem *)searchButton
{
    if (! _searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    }
    return _searchButton;
}

- (LYZAddListTableViewCell *)addListCell
{
    if(! _addListCell) {
        _addListCell = [self.tableView dequeueReusableCellWithIdentifier:@"addListCell"];
        
        if(! _addListCell) {
            _addListCell = [[LYZAddListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addListCell"];
//            _addListCell.textField.rightView = self.starButton;
//            _addListCell.textField.rightViewMode = UITextFieldViewModeAlways;
            
            _addListCell.textField.delegate = self;
        }
    }
    return _addListCell;
}

@end
