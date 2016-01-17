//
//  AidEditTaskViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/24.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidEditTaskViewController.h"

#import "XLForm.h"

@interface AidEditTaskViewController ()

@end


@implementation AidEditTaskViewController

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeForm];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initializeForm];
    }
    return self;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    
    self.title = @"发现";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO; // 当设置为YES时（默认YES），如果视图里面存在唯一一个UIScrollView或其子类View，那么它会自动设置相应的内边距，这样可以让scroll占据整个视图，又不会让导航栏遮盖
    //    self.extendedLayoutIncludesOpaqueBars = NO; // 视图是否延伸至Bar所在区域，默认为NO。（仅当Bar的默认属性为不透明时，设置为YES才有效果）
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight; // 指定视图覆盖到四周的区域，当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始(默认是UIRectEdgeAll)。
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self layoutPageSubviews];
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

- (void)initializeForm
{
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"编辑任务"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"名称" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Name" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Location
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"位置" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Location" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Date
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"data" rowType:XLFormRowDescriptorTypeDate title:@"到期日"];
    row.value = [NSDate new];
    [row.cellConfigAtConfigure setObject:[NSDate new] forKey:@"minimumDate"];
    [row.cellConfigAtConfigure setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*3)] forKey:@"maximumDate"];
    [section addFormRow:row];
    
    // DateTime
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"dateTime" rowType:XLFormRowDescriptorTypeDateTime title:@"提醒时间"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    // 重复
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"selectorPickerView" rowType:XLFormRowDescriptorTypeSelectorPickerView title:@"重复"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"从不"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"每天"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"每周"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"每月"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"每年"],
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"从不"];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)setupPageNavigation
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

#pragma mark - XLFormDescriptorDelegate

- (void)cancelPressed:(UIBarButtonItem * __unused)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    [self.tableView endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
