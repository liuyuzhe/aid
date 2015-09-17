//
//  UIScreen+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "UIScreen+LYZExtension.h"

@implementation UIScreen (LYZExtension)

+ (CGFloat)screenScale
{
    return [[UIScreen mainScreen] scale];
}

+ (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

@end
