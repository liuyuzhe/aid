//
//  AidItemsScrollViewController.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/16.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AidTitleColorGradientStyleRGB,
    AidTitleColorGradientStyleFill,
} AidTitleColorGradientStyle;


@protocol AidItemsScrollViewControllerDelegate <NSObject>

@optional
- (void)clickOrScrollDidEndWithIndex:(NSInteger)index;
- (void)repeatClickWithIndex:(NSInteger)index;

@end


@interface AidItemsScrollViewController : UIViewController

@property (nonatomic, copy) id<AidItemsScrollViewControllerDelegate> delegate;

#pragma mark - 滚动视图设置

@property (nonatomic, assign) BOOL fullScreen; /**< 内容是否全屏展示 */
@property (nonatomic, assign) CGRect contentViewFrame; /**< 内容区域大小 */
@property (nonatomic, strong) UIColor *titleScrollViewColor; /**< 标题滚动视图背景颜色 */
@property (nonatomic, strong) UIColor *contentScrollViewColor; /**< 内容滚动视图背景颜色 */

#pragma mark - 标题设置

@property (nonatomic, assign) CGFloat titleHeight; /**< 标题高度 */
@property (nonatomic, assign) CGFloat titleMargin; /**< 标题间距 */
@property (nonatomic, strong) UIColor *normalColor; /**< 正常标题颜色 */
@property (nonatomic, strong) UIColor *selectColor; /**< 选中标题颜色 */
@property (nonatomic, strong) UIFont *titleFont; /**< 标题字体 */

#pragma mark - 下标视图设置

@property (nonatomic, assign) BOOL showUnderLine; /**< 是否显示下标 */
@property (nonatomic, assign) CGFloat underLineHeight; /**< 下标高度 */
@property (nonatomic, strong) UIColor *underLineColor; /**< 下标颜色 */
@property (nonatomic, assign) BOOL delayScrollUnderLine; /**< 下标是否延迟滚动,默认为NO */

#pragma mark - 遮盖视图设置

@property (nonatomic, assign) BOOL showTitleCover; /**< 是否显示遮盖 */
@property (nonatomic, strong) UIColor *coverColor; /**< 遮盖颜色 */
@property (nonatomic, assign) CGFloat coverCornerRadius; /**< 遮盖圆角半径 */
@property (nonatomic, assign) BOOL delayScrollCover; /**< 遮盖是否延迟滚动,默认为NO */

#pragma mark - 字体缩放设置

@property (nonatomic, assign) BOOL showTitleScale; /**< 是否字体缩放 */
@property (nonatomic, assign) CGFloat titleScale; /**< 字体缩放比例 */

#pragma mark - 字体渐变设置

@property (nonatomic, assign) BOOL showTitleGradient; /**< 是否字体渐变 */
@property (nonatomic, assign) AidTitleColorGradientStyle titleColorGradientStyle; /**< 渐变样式 */

@end
