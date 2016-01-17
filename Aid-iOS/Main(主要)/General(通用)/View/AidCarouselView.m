//
//  AidCarouselView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/29.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidCarouselView.h"
#import "AidCarouselCollectionCell.h"

static CGFloat const AidMinMovingTimeInterval = 0.1; /**< 最小滚动时间间隔 */
static CGFloat const AidDefaultMovingTimeInterval = 3.; /**< 默认滚动时间间隔 */
static CGFloat const AidScrollOffsetDelta = 10.; /**< 允许滚动时偏移的误差 */

@interface AidCarouselView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LYZTimerHolderDelegate>

@property (nonatomic, strong) LYZTimerHolder *timerHolder;
@property (nonatomic, assign) BOOL needRefresh;

@end


@implementation AidCarouselView

@synthesize imageArray = _imageArray;

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0; // 设定全局的Cell间距
    flowLayout.minimumLineSpacing = 0; // 设定全局的行间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); // 设置组内边距
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向滑动
        
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        _autoMoving = NO;
        _movingTimeInterval = AidDefaultMovingTimeInterval;
        
        self.pagingEnabled = YES; // 是否按页滚动
        self.showsHorizontalScrollIndicator = NO; // 是否显示水平方向的滚动条
        self.showsVerticalScrollIndicator = NO; // 是否显示垂直方向的滚动条
        self.bounces = NO; // 是否弹跳
        self.delegate = self;
        self.dataSource = self;
        
        NSString * const identifier = NSStringFromClass([AidCarouselCollectionCell class]);
        [self registerClass:[AidCarouselCollectionCell class] forCellWithReuseIdentifier:identifier];
        
        [self registerNofitication]; // 注册通知
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 销毁通知
}

- (void)layoutSubviews
{
    if (self.needRefresh) {
        // 最左边一张图其实是最后一张图，因此移动到第二张图，也就是imageArray的第一个图
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.needRefresh = NO;
    }
    
    // layoutSubviews 仅仅会layout当前屏幕的View.所以要先滚动位置，然后调用layoutSubViews
    [super layoutSubviews];
}

#pragma mark - public methods

- (void)startMoving
{
    if (self.autoMoving) {
        [self.timerHolder startTimer:self.movingTimeInterval delegate:self repeats:YES];
    }
}

- (void)stopMoving
{
    [self.timerHolder stopTimer];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
}

#pragma mark - override super

#pragma make - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX(self.imageArray.count, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const identifier = NSStringFromClass([AidCarouselCollectionCell class]);
    AidCarouselCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    if (self.imageArray.count <= 0) {
        cell.image = self.placeholder;
        return cell;
    }
    
    cell.image = self.imageArray[indexPath.item];
    cell.imageSize = self.frame.size;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger page = 0;
    NSUInteger lastIndex = self.imageArray.count - 3;
    
    if (indexPath.item == 0) {
        page = lastIndex;
    }
    else if (indexPath.item == lastIndex) {
        page = 0;
    }
    else {
        page = indexPath.item - 1;
    }
 
    if (self.didTouchPage) {
        self.didTouchPage(page);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 拖拽开始，暂停自动轮播
    [self stopMoving];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetX = scrollView.contentOffset.x;
//    [self moveWithOffset:offsetX];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 拖拽完成，恢复自动轮播
    [self startMoving];
    
    CGFloat offsetX = scrollView.contentOffset.x;
    [self moveWithOffset:offsetX];
   
    // 用户手动拖拽的时候
    [self adjustCurrentPage:offsetX];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= (self.imageArray.count - 1) * [LYZDeviceInfo screenWidth] ) {
        [self setContentOffset:CGPointMake([LYZDeviceInfo screenWidth], 0) animated:NO];
    }
    
    // 轮播滚动的时候
    [self adjustCurrentPage:offsetX];
}

#pragma mark -

- (void)moveWithOffset:(CGFloat)offsetX
{
    // 向左滑动时切换imageView
    if (offsetX <= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.imageArray.count - 2 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    // 向右滑动时切换imageView
    if (offsetX > (self.imageArray.count - 1) * [LYZDeviceInfo screenWidth] - AidScrollOffsetDelta) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

#pragma mark - LYZTimerHolderDelegate

- (void)timerDidFire:(LYZTimerHolder *)timeHolder
{
    [self moveToNextPage];
}

#pragma mark - event response

#pragma mark - notification response

- (void)registerNofitication
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationDidBecomeActive
{
    [self startMoving];
}

- (void)applicationWillResignActive
{
    [self stopMoving];
}

#pragma mark - private methods

/** 移动到下一页 */
- (void)moveToNextPage
{
    CGPoint newContentOffset = CGPointMake(self.contentOffset.x + [LYZDeviceInfo screenWidth], 0);
    [self setContentOffset:newContentOffset animated:YES];
}

/** 调整当前页面位置 */
- (void)adjustCurrentPage:(CGFloat)offsetX
{
    NSInteger page = offsetX / [LYZDeviceInfo screenWidth] - 1;
    
    if (offsetX < [LYZDeviceInfo screenWidth]) {
        page = self.imageArray.count - 3;
    }
    else if (offsetX >= [LYZDeviceInfo screenWidth] * (self.imageArray.count - 1)) {
        page = 0;
    }
    
    if (self.didMoveToPage) {
        self.didMoveToPage(page);
    }
}

#pragma mark - getters and setters

- (LYZTimerHolder *)timerHolder
{
    if (! _timerHolder) {
        _timerHolder = [[LYZTimerHolder alloc] init];
    }
    return _timerHolder;
}

- (NSArray<UIImage *> *)imageArray
{
    if (! _imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

- (void)setImageArray:(NSArray<UIImage *> *)imageArray
{
    _imageArray = imageArray;
    
    if (imageArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:[imageArray lastObject]];
        [arr addObjectsFromArray:imageArray];
        [arr addObject:[imageArray firstObject]];
        _imageArray = [NSArray arrayWithArray:arr];
    }
    
    [self reloadData];
    
    self.needRefresh = YES;
}

- (void)setMovingTimeInterval:(NSTimeInterval)movingTimeInterval
{
    if (movingTimeInterval > AidMinMovingTimeInterval) {
        _movingTimeInterval = movingTimeInterval;
    }
}

@end
