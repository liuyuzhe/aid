//
//  AidCarouselCollectionCell.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/29.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidCarouselCollectionCell.h"

@interface AidCarouselCollectionCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end


@implementation AidCarouselCollectionCell

#pragma mark - life cycle

//+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
//{
//    NSString * const identifier = NSStringFromClass([AidCarouselCollectionCell class]);
//    AidCarouselCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    
//    return cell;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        _imageView = [[UIImageView alloc] initWithFrame:frame];
//        
//        [self.contentView addSubview:_imageView];
//    }
//    return self;
//}
//
//#pragma mark - override super
//
//#pragma mark - getters and setters
//
//- (void)setImage:(UIImage *)image
//{
//    _image = image;
//    
//    self.imageView.image = image;
//}

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置自定义的属性 如图片
        [self setUpUI];
        
    }
    return  self;
}

//设置界面
-(void)setUpUI
{
    //添加图片
    UIImageView * imageView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:imageView];
    
    self.imageView = imageView;
    
}


//重写外界传入的图片数组的setter方法 给imageView设置图片
-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    
}

//设置子视图frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
}

@end
