//
//  AidDiscoverViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/26.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidDiscoverViewController.h"
#import "AidDiscoverChildViewController.h"

@interface AidDiscoverViewController ()

@end


@implementation AidDiscoverViewController

#pragma mark - life cycle

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
//    }
//    return self;
//}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = contentView;
    
    self.title = @"发现";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.automaticallyAdjustsScrollViewInsets = NO; // 当设置为YES时（默认YES），如果视图里面存在唯一一个UIScrollView或其子类View，那么它会自动设置相应的内边距，这样可以让scroll占据整个视图，又不会让导航栏遮盖
//    self.extendedLayoutIncludesOpaqueBars = NO; // 视图是否延伸至Bar所在区域，默认为NO。（仅当Bar的默认属性为不透明时，设置为YES才有效果）
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight; // 指定视图覆盖到四周的区域，当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始(默认是UIRectEdgeAll)。
}

- (void)viewDidLoad
{
    [self setUpAllViewController];
    
    // 滚动视图设置
    self.titleScrollViewColor = [UIColor grayColor];
    
    // 标题设置
    
    // 字体渐变设置
    self.showTitleGradient = YES;
    self.titleColorGradientStyle = AidTitleColorGradientStyleRGB;

    // 下标视图设置
    self.showUnderLine = YES;
    self.underLineColor = [UIColor cyanColor];
    self.delayScrollUnderLine = NO;
    
    // 遮盖视图设置
//    self.showTitleCover = YES;
//    self.coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
//    self.coverCornerRadius = 10;
//    self.delayScrollCover = NO;
    
    [super viewDidLoad]; // 必须先构建完所有子视图控制器后,才能调用viewDidLoad

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

- (void)setUpAllViewController
{
    NSArray *titleNames = @[@"精选", @"附近", @"健康", @"生活", @"工作"];
    for (NSString *title in titleNames) {
        AidDiscoverChildViewController *childVC = [[AidDiscoverChildViewController alloc] init];
        childVC.title = title;
        
        [self addChildViewController:childVC];
    }
}

- (void)setupPageNavigation
{
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
}

#pragma mark - override super

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

#pragma mark - event response

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

@end
