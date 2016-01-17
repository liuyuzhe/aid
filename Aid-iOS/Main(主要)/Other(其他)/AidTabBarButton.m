//
//  AidTabBarButton.m
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import "AidTabBarButton.h"

static const CGFloat AidTabBarButtonImageRatio = 0.6;

@implementation AidTabBarButton

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //字体居中
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        //文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        //添加一个提醒数字按钮
        UIButton *badgeButton = [[UIButton alloc] init];
        [self addSubview:badgeButton];
    }
    return self;
}

#pragma mark - override super

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * AidTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height -titleY;
    return  CGRectMake(0, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * AidTabBarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

#pragma mark - getters and setters

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self setTitle:item.title forState:UIControlStateNormal];
    
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
}

@end
