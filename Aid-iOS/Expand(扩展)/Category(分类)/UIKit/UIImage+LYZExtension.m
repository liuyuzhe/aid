//
//  UIImage+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/15.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "UIImage+LYZExtension.h"
#import "UIColor+LYZExtension.h"
#import "LYZMathMethod.h"
#import "LYZMemoryCache.h"
#import "LYZMathMacro.h"

@implementation UIImage (LYZExtension)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    
    UIImage *image = [[LYZMemoryCache sharedInstance] objectForKey:[color description]];
    if (! image) {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        BOOL opaque = LYZCGFloatEqual(color.alpha, 1.0);
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0);
        
        [color setFill]; // 设置填充色
        UIRectFill(rect); // 绘制矩形（只填充，无边框）
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[LYZMemoryCache sharedInstance] setObject:image forKey:[color description]];
    }
    
    return image;
}

- (UIImage *)subimageInRect:(CGRect)rect
{
    CGFloat scale = MAX(self.scale, 1);
    rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    CGImageRef subimageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subimageRef), CGImageGetHeight(subimageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subimageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subimageRef scale:self.scale orientation:self.imageOrientation];
    
    UIGraphicsEndImageContext();
    CGImageRelease(subimageRef);
    
    return smallImage;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    view.transform = transform;
    CGSize rotatedSize = view.frame.size;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(context, radians);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:LYZDegreesToRadian(degrees)];
}

- (UIImage *)imageWithTransform:(CGAffineTransform)transform
{
    if (self.size.width == 0 || self.size.height == 0) {
        return nil;
    }
    
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), self.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithSize:(CGSize)size
{
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}

@end
