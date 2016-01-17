//
//  AidCarouselView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/29.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pageAction)(NSInteger pageIndex);

@interface AidCarouselView : UICollectionView

@property (nonatomic, copy) pageAction didTouchPage; /**< 点击页面时触发 */
@property (nonatomic, copy) pageAction didMoveToPage; /**< 页面滚动结束时触发 */

@property (nonatomic, strong) UIImage *placeholder; /**< 没有轮播图时的占位图 */
@property (nonatomic, strong) NSArray<UIImage *> *imageArray; /**< 轮播图片的数组。刷新可再次赋值 */

@property (nonatomic, assign) BOOL autoMoving; /**< 是否自动轮播，默认为NO */
@property (nonatomic, assign) NSTimeInterval movingTimeInterval; /**< 滚动速率，默认为3.0 */

- (void)startMoving; /**< 开启轮播(仅当 autoMoving = YES 有效)，一般在 viewDidAppear 中调用 */
- (void)stopMoving; /**< 停止轮播, 一般在 viewDidDisappear 中调用 */

@end
