//
//  AidEditTaskViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/24.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidEditTaskViewController.h"

#import "XLForm.h"
#import "LYZDateAndTimeValueTransformer.h"

#import "AidTaskRecord.h"

@interface AidEditTaskViewController ()

@property (nonatomic, strong) XLFormRowDescriptor *nameRow;
@property (nonatomic, strong) XLFormRowDescriptor *startRow;
@property (nonatomic, strong) XLFormRowDescriptor *endRow;
@property (nonatomic, strong) XLFormRowDescriptor *alertRow;
@property (nonatomic, strong) XLFormRowDescriptor *repeatRow;
@property (nonatomic, strong) XLFormRowDescriptor *noteRow;

@end


@implementation AidEditTaskViewController

@synthesize taskRecord = _taskRecord;

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
//    self.view.tintColor =  [UIColor blueColor];
    
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
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"编辑任务"];
    XLFormSectionDescriptor *section;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Name
    _nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"Name" rowType:XLFormRowDescriptorTypeText];
    [_nameRow.cellConfigAtConfigure setObject:@"请输入任务名称" forKey:@"textField.placeholder"];
//    row.required = YES;
//    row.requireMsg = @"任务名称不能为空！";
    [section addFormRow:_nameRow];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Start
    _startRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"Starts" rowType:XLFormRowDescriptorTypeDate title:@"开始日期"];
//    [_startRow.cellConfigAtConfigure setObject:[NSDate new] forKey:@"minimumDate"];
    _startRow.valueTransformer = [LYZDateValueTrasformer class];
    _startRow.value = [NSDate date];
    [section addFormRow:_startRow];
    
    // End
    _endRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"Ends" rowType:XLFormRowDescriptorTypeDate title:@"结束日期"];
    _endRow.valueTransformer = [LYZDateValueTrasformer class];
    _endRow.value = [[NSDate date] dateByAddingWeeks:1];
    [section addFormRow:_endRow];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Alert
    _alertRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"dateTime" rowType:XLFormRowDescriptorTypeDateTime title:@"提醒时间"];
    _alertRow.valueTransformer = [LYZDateAndTimeValueTransformer class];
    _alertRow.value = [[NSDate date] dateByAddingDays:1];
    [section addFormRow:_alertRow];
    
    // Repeat
    _repeatRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"repeat" rowType:XLFormRowDescriptorTypeSelectorPush title:@"重复周期"];
    _repeatRow.selectorTitle = @"重复周期";
    _repeatRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"从不"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"工作日"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"周末"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"每天"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"每周"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(5) displayText:@"每月"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(6) displayText:@"每年"],
                            ];
    _repeatRow.value = [XLFormOptionsObject formOptionsOptionForValue:@(0) fromOptions:_repeatRow.selectorOptions];
    [section addFormRow:_repeatRow];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    // Notes
    _noteRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"notes" rowType:XLFormRowDescriptorTypeTextView];
    [_noteRow.cellConfigAtConfigure setObject:@"添加备注..." forKey:@"textView.placeholder"];
    [section addFormRow:_noteRow];
    
    self.form = form;
}

- (void)setupPageNavigation
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonAction:)];
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

- (void)cancelButtonAction:(UIBarButtonItem * __unused)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonAction:(UIBarButtonItem * __unused)button
{
    self.taskRecord.name = (NSString *)self.nameRow.value;
    self.taskRecord.startTime = [NSNumber numberWithDouble:[(NSDate *)self.startRow.value timeIntervalSinceReferenceDate]];
    self.taskRecord.endTime = [NSNumber numberWithDouble:[(NSDate *)self.endRow.value timeIntervalSinceReferenceDate]];
    self.taskRecord.alarmTime = [NSNumber numberWithDouble:[(NSDate *)self.alertRow.value timeIntervalSinceReferenceDate]];
    self.taskRecord.repeat = ((XLFormOptionsObject *)self.repeatRow.value).formValue;
    self.taskRecord.note = (NSString *)self.noteRow.value;

    if ([self.delegate respondsToSelector:@selector(editTaskRecord:configureViewController:)]) {
        [self.delegate editTaskRecord:self.taskRecord configureViewController:self];
    }
    
//    NSArray * validationErrors = [self formValidationErrors];
//    if (validationErrors.count > 0){
//        [self showFormValidationError:[validationErrors firstObject]];
//        return;
//    }
    
//    [self.tableView endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (AidTaskRecord *)taskRecord
{
    if (! _taskRecord) {
        _taskRecord = [[AidTaskRecord alloc] init];
    }
    return _taskRecord;
}

- (void)setTaskRecord:(AidTaskRecord *)taskRecord
{
    _taskRecord = taskRecord;
    
    self.nameRow.value = taskRecord.name;
    self.startRow.value = [NSDate dateWithTimeIntervalSinceReferenceDate:taskRecord.startTime.doubleValue];
    self.endRow.value = [NSDate dateWithTimeIntervalSinceReferenceDate:taskRecord.endTime.doubleValue];
    self.alertRow.value = [NSDate dateWithTimeIntervalSinceReferenceDate:taskRecord.alarmTime.doubleValue];
//    taskRecord.repeat = @(5);
    self.repeatRow.value = [XLFormOptionsObject formOptionsOptionForValue:taskRecord.repeat fromOptions:self.repeatRow.selectorOptions];
    self.noteRow.value = taskRecord.note;
    
    [self updateFormRow:self.nameRow];
    [self updateFormRow:self.startRow];
    [self updateFormRow:self.endRow];
    [self updateFormRow:self.alertRow];
    [self updateFormRow:self.repeatRow];
    [self updateFormRow:self.noteRow];
}

@end
