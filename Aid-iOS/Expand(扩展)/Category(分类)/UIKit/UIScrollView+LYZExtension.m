//
//  UIScrollView+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "UIScrollView+LYZExtension.h"

@implementation UIScrollView (LYZExtension)

- (void)scrollToTop
{
    [self scrollToTopAnimated:YES];
}

- (void)scrollToBottom
{
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToLeft
{
    [self scrollToLeftAnimated:YES];
}

- (void)scrollToRight
{
    [self scrollToRightAnimated:YES];
}

- (void)scrollToTopAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
