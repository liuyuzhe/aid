//
//  AidItemsScrollView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/25.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AidItemsConfig : NSObject

@property (nonatomic, assign) CGFloat itemWidth; /**< 文本宽度，默认为0（等分滚动视图）*/
@property (nonatomic, strong) UIFont *itemFont; /**< 文本字体，默认为16号系统字体 */
@property (nonatomic, strong) UIColor *textColor; /**< 文本颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *selectColor; /**< 选择文本颜色，默认为绿色 */
@property (nonatomic, strong) UIColor *chooseColor; /**< 选择视图颜色，默认为红色 */

@end



@protocol AidItemsScrollViewDelegate <NSObject>

@optional
- (void)tapItemWithIndex:(NSInteger)index animation:(BOOL)animation;

@end


@interface AidItemsScrollView : UIScrollView

@property (nonatomic, weak) id<AidItemsScrollViewDelegate> itemsDelegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign) BOOL tapAnimation; // default is YES;

- (instancetype)initWithFrame:(CGRect)frame
                  itemsConfig:(AidItemsConfig *)config
                   titleArray:(NSArray <NSString *> *)titleArray;

/** 在 UIScrollViewDelegate 的 scrollViewDidScroll 中回调 */
- (void)moveToIndex:(CGFloat)offset;
/** 在 UIScrollViewDelegate 的 scrollViewDidEndDecelerating 中回调 */
- (void)endMoveToIndex:(CGFloat)offset;

@end
