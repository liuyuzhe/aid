//
//  AidItemsScrollViewController.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/16.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidItemsScrollViewController.h"
#import "AidDisplayTitleLabel.h"

#import "AidCollectionViewFlowLayout.h"

static CGFloat const AidDefaultTitleMargin = 20; /**< 默认标题间距 */
static CGFloat const AidUnderLineHeight = 2; /**< 默认下标高度 */
static CGFloat const AidTitleTransformScale = 1.3; /**< 默认字体缩放比例 */
static CGFloat const AidCoverViewBorder = 5; /**< 遮盖视图边缘 */

@interface AidItemsScrollViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *contentView; /**< 整体内容视图 */
@property (nonatomic, strong) UIScrollView *titleScrollView; /**< 标题滚动视图 */
@property (nonatomic, strong) UICollectionView *contentScrollView; /**< 内容滚动视图 */
@property (nonatomic, strong) UIView *underLine; /**< 下标视图 */
@property (nonatomic, strong) UIView *coverView; /**< 遮盖视图 */

@property (nonatomic, strong) NSMutableArray *titleWidths; /**< 所以标题宽度数组 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels; /**< 标题数组 */

@property (nonatomic, assign) CGFloat lastOffsetX; /**< 上一次内容滚动视图偏移量 */
@property (nonatomic, assign) BOOL isClickTitle; /**< 是否点击 */
@property (nonatomic, assign) BOOL isAniming; /**< 是否在动画 */
@property (nonatomic, assign) NSInteger selIndex; /**< 上一次选中角标 */

@end


@implementation AidItemsScrollViewController

@synthesize contentViewFrame = _contentViewFrame;

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO; // 当设置为YES时（默认YES），如果视图里面存在唯一一个UIScrollView或其子类View，那么它会自动设置相应的内边距，这样可以让scroll占据整个视图，又不会让导航栏遮盖
    
    [self setupPageSubviews];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleScrollView];
    [self.contentView insertSubview:self.contentScrollView belowSubview:self.titleScrollView];
    if (self.showUnderLine) {
        [self.titleScrollView addSubview:self.underLine];
    }
    if (self.showTitleCover) {
        [self.titleScrollView insertSubview:self.coverView atIndex:0];
    }
    
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

#pragma mark - public methods

#pragma mark - life cycle helper

- (void)commonInit
{
    // 内容设置
    _fullScreen = NO;
    _titleScrollViewColor = nil;

    // 标题设置
    _titleHeight = AidNavgationBarHeight;
    _titleMargin = AidDefaultTitleMargin;
    _normalColor = [UIColor blackColor];
    _selectColor = [UIColor redColor];
    _titleFont = [UIFont systemFontOfSize:15];
    
    // 下标视图设置
    _showUnderLine = NO;
    _underLineHeight = AidUnderLineHeight;
    _underLineColor = [UIColor redColor];
    _delayScrollUnderLine = NO;
    
    // 遮盖视图设置
    _showTitleCover = NO;
    _coverColor = [UIColor lightGrayColor];
    _coverCornerRadius = 5;
    _delayScrollCover = NO;
    
    // 字体缩放设置
    _showTitleScale = NO;
    _titleScale = AidTitleTransformScale;
    
    // 字体渐变设置
    _showTitleGradient = NO;
    _titleColorGradientStyle = AidTitleColorGradientStyleRGB;
}

- (void)setupPageSubviews
{
    [self setUpTitleWidth];
    [self setUpAllTitle];
}

#pragma mark -

/** 设置所有标题宽度 */
- (void)setUpTitleWidth
{
    CGFloat totalWidth = 0;
    NSUInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i++) {
        NSString *title = [self.childViewControllers[i] valueForKeyPath:@"title"];
        if ([title isKindOfClass:[NSNull class]]) {
            NSException *excp = [NSException exceptionWithName:@"AidItemsScrollViewController" reason:@"必须设置子视图控制器的 title 属性，用于标题的展示" userInfo:nil];
            [excp raise];
        }
        
        // 获取文字尺寸
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:self.titleFont}
                                                 context:nil];
        CGFloat width = titleBounds.size.width;
        
        [self.titleWidths addObject:@(width)];

        totalWidth += width;
    }
    
    if (totalWidth < [LYZDeviceInfo screenWidth]) {
        CGFloat titleMargin = ([LYZDeviceInfo screenWidth] - totalWidth) / (count + 1);
        self.titleMargin = titleMargin < AidDefaultTitleMargin? AidDefaultTitleMargin: titleMargin;
    }
    
    self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.titleMargin);
}

/** 设置所有标题视图 */
- (void)setUpAllTitle
{
    NSUInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; ++i) {
        CGFloat width = [self.titleWidths[i] floatValue];
        UILabel *lastLabel = [self.titleLabels lastObject];
        UILabel *label = [[AidDisplayTitleLabel alloc] initWithFrame:CGRectMake(self.titleMargin + lastLabel.right, 0, width, self.titleHeight)];
        label.textColor = self.normalColor;
        label.font = self.titleFont;
        label.text = self.childViewControllers[i].title;
        label.tag = 100 + i;
        
        // 监听标题点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        [label addGestureRecognizer:tap];
        
        if (i == 0) {
            [self itemAction:tap];
        }
        
        [self.titleLabels addObject:label];
        [self.titleScrollView addSubview:label];
    }
   
    self.titleScrollView.contentSize = CGSizeMake(self.titleLabels.lastObject.right, 0); // 禁止垂直滚动
}

- (void)layoutPageSubviews
{
}

#pragma mark - override super

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const identifier = NSStringFromClass([UICollectionViewCell class]);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 添加控制器
    UIViewController *contentVC = self.childViewControllers[indexPath.row];
    contentVC.view.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    
    [cell.contentView addSubview:contentVC.view];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isAniming) {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger leftIndex = offsetX / [LYZDeviceInfo screenWidth];
    UILabel *leftLabel = self.titleLabels[leftIndex];
    
    NSInteger rightIndex = leftIndex + 1;
    UILabel *rightLabel = nil;
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }

    [self moveWithOffset:offsetX leftLabel:leftLabel rightLabel:rightLabel];
    
    // 记录上一次的偏移量
    self.lastOffsetX = offsetX;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = [LYZDeviceInfo screenWidth];
    
    NSInteger extra = offsetXInt % screenWInt;
    if (extra > [LYZDeviceInfo screenWidth] * 0.5) { // 往右边移动
        self.isAniming = YES;
        offsetX = offsetX + ([LYZDeviceInfo screenWidth] - extra);
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extra < [LYZDeviceInfo screenWidth] * 0.5 && extra > 0){ // 往左边移动
        self.isAniming = YES;
        offsetX =  offsetX - extra;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // 获取角标
    NSInteger index = offsetX / [LYZDeviceInfo screenWidth];
    
    [self selectLabel:self.titleLabels[index]];
    
    if ([self.delegate respondsToSelector:@selector(clickOrScrollDidEndWithIndex:)])
    {
        [self.delegate clickOrScrollDidEndWithIndex:index];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isAniming = NO;
}

#pragma mark -

- (void)moveWithOffset:(CGFloat)offsetX leftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel
{
    if (self.showUnderLine && ! self.delayScrollUnderLine && ! self.isClickTitle) {
        [self setUpUnderLineOffset:offsetX leftLabel:leftLabel rightLabel:rightLabel];
    }
    
    if (self.showTitleCover && ! self.delayScrollCover && ! self.isClickTitle) {
        [self setUpCoverOffset:offsetX leftLabel:leftLabel rightLabel:rightLabel];
    }

    if (self.showTitleScale) {
        [self setUpTitleScaleWithOffset:offsetX leftLabel:leftLabel rightLabel:rightLabel];
    }
    
    if (self.showTitleGradient) {
        [self setUpTitleColorGradientWithOffset:offsetX leftLabel:leftLabel rightLabel:rightLabel];
    }
}

/** 字体缩放设置 */
- (void)setUpTitleScaleWithOffset:(CGFloat)offsetX leftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel
{
    NSInteger index = leftLabel.tag - 100;
    CGFloat rightSacle = offsetX / [LYZDeviceInfo screenWidth] - index;
    CGFloat leftScale = 1 - rightSacle;
    
    CGFloat scaleTransform = self.titleScale - 1;
    
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    rightLabel.transform = CGAffineTransformMakeScale(rightSacle * scaleTransform + 1, rightSacle * scaleTransform + 1);
}

/** 下标视图设置 */
- (void)setUpUnderLineOffset:(CGFloat)offsetX leftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel
{
    CGFloat offsetDelta = offsetX - self.lastOffsetX;
    CGFloat centerDelta = rightLabel.left - leftLabel.left; // 两个标题中心点距离
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel]; // 标题宽度差值
    
    CGFloat leftOffset = offsetDelta * centerDelta / [LYZDeviceInfo screenWidth];
    CGFloat widthOffset = offsetDelta * widthDelta / [LYZDeviceInfo screenWidth];
    
    self.underLine.left += leftOffset;
    self.underLine.width += widthOffset;
}

/** 获取两个标题按钮宽度差值 */
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:self.titleFont}
                                                        context:nil];
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:self.titleFont}
                                                       context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}

/** 遮盖视图设置 */
- (void)setUpCoverOffset:(CGFloat)offsetX leftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel
{
    CGFloat offsetDelta = offsetX - self.lastOffsetX; // 获取移动距离
    CGFloat centerDelta = rightLabel.left - leftLabel.left; // 两个标题中心点距离
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel]; // 标题宽度差值
    
    CGFloat leftOffset = offsetDelta * centerDelta / [LYZDeviceInfo screenWidth];
    CGFloat widthOffset = offsetDelta * widthDelta / [LYZDeviceInfo screenWidth];
    
    self.coverView.left += leftOffset;
    self.coverView.width += widthOffset;
}

/** 字体渐变设置 */
- (void)setUpTitleColorGradientWithOffset:(CGFloat)offsetX leftLabel:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel
{
    NSInteger index = leftLabel.tag - 100;
    CGFloat rightSacle = offsetX / [LYZDeviceInfo screenWidth] - index;
    CGFloat leftScale = 1 - rightSacle;
    
    // RGB渐变
    if (self.titleColorGradientStyle == AidTitleColorGradientStyleRGB) {
        CGFloat red = self.selectColor.red - self.normalColor.red;
        CGFloat green = self.selectColor.green - self.normalColor.green;
        CGFloat blue = self.selectColor.blue - self.selectColor.blue;
        
        UIColor *rightColor = LYZColorRGB(self.normalColor.red + red * rightSacle, self.normalColor.green + green * rightSacle, self.normalColor.blue + blue * rightSacle);
        UIColor *leftColor = LYZColorRGB(self.normalColor.red + red * leftScale, self.normalColor.green + green * leftScale, self.normalColor.blue + blue * leftScale);
        
        rightLabel.textColor = rightColor;
        leftLabel.textColor = leftColor;
    }
    
    // 填充渐变
    if (self.titleColorGradientStyle == AidTitleColorGradientStyleFill) {
        CGFloat offsetDelta = offsetX - self.lastOffsetX;
        AidDisplayTitleLabel *leftTitle = (AidDisplayTitleLabel *)leftLabel;
        AidDisplayTitleLabel *rightTitle = (AidDisplayTitleLabel *)rightLabel;
        
        if (offsetDelta > 0) { // 往右边
            rightTitle.fillColor = self.selectColor;
            rightTitle.progress = rightSacle;
            
            leftTitle.fillColor = self.normalColor;
            leftTitle.progress = rightSacle;
        }
        else if(offsetDelta < 0){ // 往左边
            rightTitle.textColor = self.normalColor;
            rightTitle.fillColor = self.selectColor;
            rightTitle.progress = rightSacle;
            
            leftTitle.textColor = self.selectColor;
            leftTitle.fillColor = self.normalColor;
            leftTitle.progress = rightSacle;
        }
    }
}


#pragma mark - event response

- (void)itemAction:(UITapGestureRecognizer *)tap
{
    self.isClickTitle = YES;
    
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = tap.view.tag - 100;
    
    [self selectLabel:label];
    
    CGFloat offsetX = [LYZDeviceInfo screenWidth] * index;
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
    _lastOffsetX = offsetX;
    

    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
    if (vc.view) {
        if ([self.delegate respondsToSelector:@selector(clickOrScrollDidEndWithIndex:)])
        {
            [self.delegate clickOrScrollDidEndWithIndex:index];
        }

        if (self.selIndex == index) {
            if ([self.delegate respondsToSelector:@selector(repeatClickWithIndex:)])
            {
                [self.delegate repeatClickWithIndex:index];
            }
            self.selIndex = index;
        }
    }
    
    self.isClickTitle = NO;
}

#pragma mark -

/** 选中标题 */
- (void)selectLabel:(UILabel *)label
{
    [self changeLabelColor:label];
    
    [self setLabelTitleCenter:label];
    
    if (self.showUnderLine) {
        [self setUpUnderLine:label];
    }
    
    if (self.showTitleCover) {
        [self setUpCoverView:label];
    }
}

/** 改变标题颜色与缩放 */
- (void)changeLabelColor:(UILabel *)label
{
    for (AidDisplayTitleLabel *labelView in self.titleLabels) {
        if (label == labelView) {
            continue;
        }
        
        if (self.showTitleScale) {
            labelView.transform = CGAffineTransformIdentity;
        }
        
        labelView.textColor = self.normalColor;
        
        if (self.showTitleGradient && self.titleColorGradientStyle == AidTitleColorGradientStyleFill) {
            labelView.fillColor = self.normalColor;
            labelView.progress = 1;
        }
    }
    
    // 标题缩放
    if (self.showTitleScale) {
        CGFloat scaleTransform = self.titleScale;
        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
    }
    
    // 修改标题选中颜色
    label.textColor = self.selectColor;
}

/** 设置标题居中显示 */
- (void)setLabelTitleCenter:(UILabel *)label
{
    CGFloat offsetX = label.center.x - [LYZDeviceInfo screenWidth] * 0.5;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - [LYZDeviceInfo screenWidth] + self.titleMargin;
    offsetX = LYZBoundFloat(offsetX, 0, maxOffsetX);
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/** 下标视图设置 */
- (void)setUpUnderLine:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:self.titleFont}
                                                  context:nil];
    
    self.underLine.top = label.height - self.underLineHeight;
    self.underLine.height = self.underLineHeight;
    
    // 开始不需要动画
    if (self.underLine.left == 0) {
        self.underLine.width = titleBounds.size.width;
        self.underLine.left = label.left;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.underLine.width = titleBounds.size.width;
        self.underLine.left = label.left;
    }];
}

/** 遮盖视图设置 */
- (void)setUpCoverView:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:self.titleFont}
                                                  context:nil];
    
    CGFloat coverH = titleBounds.size.height + 2 * AidCoverViewBorder;
    CGFloat coverW = titleBounds.size.width + 2 * AidCoverViewBorder;
    
    self.coverView.top = (label.height - coverH) * 0.5;
    self.coverView.height = coverH;
    
    // 开始不需要动画
    if (self.coverView.left == 0) {
        self.coverView.width = coverW;
        self.coverView.left = label.left - AidCoverViewBorder;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.width = coverW;
        self.coverView.left = label.left - AidCoverViewBorder;
    }];
    
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (UIView *)contentView
{
    if (! _contentView) {
        CGFloat height = self.navigationController ? AidNavHeadHeigtht : AidStatusBarHeight;
        CGFloat contentY = self.fullScreen ? 0 : height;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentY, [LYZDeviceInfo screenWidth], [LYZDeviceInfo screenHeight] - contentY)];
    }
    return _contentView;
}

- (UIScrollView *)titleScrollView
{
    if (! _titleScrollView) {
        CGFloat height = self.navigationController ? AidNavHeadHeigtht : AidStatusBarHeight;
        CGFloat titleY = self.fullScreen ? height : 0;
        
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleY, [LYZDeviceInfo screenWidth], self.titleHeight)];
        _titleScrollView.directionalLockEnabled = YES; // 是否只能在一个方向上滚动
        _titleScrollView.alwaysBounceVertical = NO; // 垂直方向是否弹跳
        _titleScrollView.showsHorizontalScrollIndicator = NO; // 是否显示水平方向的滚动条
        _titleScrollView.showsVerticalScrollIndicator = NO; // 是否显示垂直方向的滚动条
        _titleScrollView.scrollsToTop = NO; // 是否滚动到顶部
    }
    return _titleScrollView;
}

- (UICollectionView *)contentScrollView
{
    if (! _contentScrollView) {
        CGFloat scrollY = self.fullScreen ? 0 : self.titleScrollView.height;
        AidCollectionViewFlowLayout *layout = [[AidCollectionViewFlowLayout alloc] init]; // 创建布局
        
        _contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, scrollY, [LYZDeviceInfo screenWidth], self.contentView.height - scrollY) collectionViewLayout:layout];
        NSString * const identifier = NSStringFromClass([UICollectionViewCell class]);
        [_contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        _contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * [LYZDeviceInfo screenWidth], 0); // 禁止垂直滚动
        _contentScrollView.bounces = NO; // 是否弹跳
        _contentScrollView.pagingEnabled = YES; // 是否按页滚动
        _contentScrollView.showsHorizontalScrollIndicator = NO; // 是否显示水平方向的滚动条
        _contentScrollView.showsVerticalScrollIndicator = YES; // 是否显示垂直方向的滚动条
        _contentScrollView.scrollsToTop = YES; // 是否滚动到顶部
        _contentScrollView.dataSource = self;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (UIView *)underLine
{
    if (! _underLine) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = self.underLineColor;
    }
    return _underLine;
}

- (UIView *)coverView
{
    if (! _coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = self.coverColor;
        _coverView.layer.cornerRadius = self.coverCornerRadius; // 圆角
    }
    return _coverView;
}

- (NSMutableArray *)titleWidths
{
    if (! _titleWidths) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (NSMutableArray *)titleLabels
{
    if (! _titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

#pragma mark -

- (CGRect)contentViewFrame
{
    return self.contentView.frame;
}

- (void)setContentViewFrame:(CGRect)contentViewFrame
{
    _contentViewFrame = contentViewFrame;
    
    self.contentView.frame = contentViewFrame;
}

- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor
{
    _titleScrollViewColor = titleScrollViewColor;
    
    self.titleScrollView.backgroundColor = titleScrollViewColor;
}

- (void)setContentScrollViewColor:(UIColor *)contentScrollViewColor
{
    _contentScrollViewColor = contentScrollViewColor;
    
    self.contentScrollView.backgroundColor = contentScrollViewColor;
}

- (void)setShowUnderLine:(BOOL)showUnderLine
{
    if (self.showUnderLine) {
        NSException *excp = [NSException exceptionWithName:@"AidItemsScrollViewController" reason:@"字体缩放效果和下标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _showUnderLine = showUnderLine;
}

- (void)setShowTitleScale:(BOOL)showTitleScale
{
    if (self.showTitleScale) {
        NSException *excp = [NSException exceptionWithName:@"AidItemsScrollViewController" reason:@"字体缩放效果和下标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _showTitleScale = showTitleScale;
}

@end
