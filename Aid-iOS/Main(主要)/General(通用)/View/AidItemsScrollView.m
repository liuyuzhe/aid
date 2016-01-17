//
//  AidItemsScrollView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/25.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidItemsScrollView.h"

@implementation AidItemsConfig

- (instancetype)init
{
    if (self = [super init]) {
        _itemWidth = 0;
        _itemFont = [UIFont systemFontOfSize:16];
        _textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        _selectColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        _chooseColor = [UIColor colorWithRed:61/255.0 green:209/255.0 blue:165/255.0 alpha:1];
    }
    return self;
}

@end



@interface AidItemsScrollView ()

@property (nonatomic, strong) UIView *chooseView; /**< 选择视图 */
@property (nonatomic, strong) AidItemsConfig *config; /**< 配置 */
@property (nonatomic, assign, readwrite) NSInteger currentIndex; /**< 当前Item索引 */
@property (nonatomic, strong) NSArray<NSString *> *titleArray; /**< title数组 */

- (void)changeItemColor:(NSInteger)index; /**< 改变Item颜色 */
- (void)changeChooseView:(NSInteger)index; /**< 改变选择视图位置 */
- (void)changeScrollOffset:(NSInteger)index; /**< 改变滚动视图位置 */
- (NSInteger)changeProgressToInteger:(CGFloat)offset; /**< 进度条位置取整 */

@end


@implementation AidItemsScrollView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
                  itemsConfig:(AidItemsConfig *)config
                   titleArray:(NSArray <NSString *> *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        _config = config;
        _titleArray = titleArray;
        _tapAnimation = YES;
        if (_config.itemWidth == 0) {
            _config.itemWidth = self.width / titleArray.count;
        }
        
        self.contentSize = CGSizeMake(_config.itemWidth * titleArray.count, 0); // 禁止垂直滚动
        self.directionalLockEnabled = YES; // 是否只能在一个方向上滚动
        self.alwaysBounceVertical = NO; // 垂直方向遇到边框是否反弹
        self.showsHorizontalScrollIndicator = NO; // 是否显示水平方向的滚动条
        self.showsVerticalScrollIndicator = NO; // 是否显示垂直方向的滚动条
        self.scrollsToTop = NO; // 是否滚动到顶部

        [self setupPageSubviews];
        
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - public methods

- (void)moveToIndex:(CGFloat)offset
{
    NSInteger tempIndex = [self changeProgressToInteger:offset];
    
    if (tempIndex != self.currentIndex) {
        //保证在一个item内滑动，只执行一次
        [self changeChooseView:tempIndex];
        [self changeItemColor:tempIndex];
    }
    
    self.currentIndex = tempIndex;
}

- (void)endMoveToIndex:(CGFloat)offset
{
    self.currentIndex = [self changeProgressToInteger:offset];
    
    [self changeChooseView:self.currentIndex];
    [self changeItemColor:self.currentIndex];
    
    [self changeScrollOffset:self.currentIndex];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    CGFloat width = _config.itemWidth;
    CGFloat height = self.height;
    
    // 选择视图
    _chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _chooseView.backgroundColor = _config.chooseColor;
    [_chooseView setRoundedCorner:5];
    [self addSubview:_chooseView];
    
    // 滚动视图上的tabBar视图:
    for (int i = 0; i < _titleArray.count; ++i) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        button.tag = 100 + i;
        button.titleLabel.font = _config.itemFont;
        
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:_config.textColor forState:UIControlStateNormal];
        [button setTitleColor:_config.selectColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            _currentIndex = i;
            button.selected = YES;
        }
        
        [self addSubview:button];
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
}

#pragma mark - override super

#pragma mark - event response

- (void)itemButtonAction:(UIButton *)button
{
    self.currentIndex = button.tag - 100;
    
    if (self.tapAnimation) {
        // 有动画，由 call is pageScrollView 带动线条，改变颜色
    }
    else {
        // 无动画，需要手动移动选择视图，改变颜色
        [self changeItemColor:self.currentIndex];
        [self changeChooseView:self.currentIndex];
    }
        
    [self changeScrollOffset:self.currentIndex];
    
    if ([self.itemsDelegate respondsToSelector:@selector(tapItemWithIndex:animation:)])
    {
        [self.itemsDelegate tapItemWithIndex:self.currentIndex animation:self.tapAnimation];
    }
}

#pragma mark - notification response

#pragma mark - private methods

- (void)changeItemColor:(NSInteger)index
{
    for (int i = 0; i < self.titleArray.count; ++i) {
        UIButton *button = (UIButton *)[self viewWithTag:i + 100];
        
        if (button.tag == index + 100) {
            button.selected = YES;
        }
        else {
            button.selected = NO;
        }
    }
}

- (void)changeChooseView:(NSInteger)index
{
    CGRect rect = self.chooseView.frame;
    rect.origin.x = index * self.config.itemWidth;
    self.chooseView.frame = rect;
}

- (void)changeScrollOffset:(NSInteger)index
{
    CGFloat halfWidth = CGRectGetWidth(self.frame) / 2.0;
    CGFloat scrollWidth = self.contentSize.width;
    
    CGFloat leftSpace = self.config.itemWidth * index - halfWidth + self.config.itemWidth / 2.0;
    leftSpace = LYZBoundFloat(leftSpace, 0, scrollWidth - 2 * halfWidth);
    
    [self setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
}

- (NSInteger)changeProgressToInteger:(CGFloat)offset
{
    NSInteger max = self.titleArray.count;
    NSInteger min = 0;
    
    NSInteger index = 0;
    if (offset < min + 0.5) {
        index = min;
    }
    else if (offset >= max - 0.5) {
        index = max;
    }
    else {
        index = (offset + 0.5) / 1;
    }
    
    return index;
}

#pragma mark - getters and setters

@end
