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

#pragma maek - public method

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
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

- (UIImage *)horizontalStretchImageWithEdge:(CGFloat)edge
{
    UIEdgeInsets insets = {0, edge, 0, edge};
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)verticalStretchImageWithEdge:(CGFloat)edge
{
    UIEdgeInsets insets = {edge, 0, edge, 0};
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)stretchImageWithEdge:(CGFloat)edge
{
    UIEdgeInsets insets = {edge, edge, edge, edge};
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)horizontalTileImageWithEdge:(CGFloat)edge
{
    UIEdgeInsets insets = {0, edge, 0, edge};
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)verticalTileImageWithEdge:(CGFloat)edge
{
    UIEdgeInsets insets = {edge, 0, edge, 0};
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)tileImageWithEdge:(CGFloat)edge
{
    UIEdgeInsets insets = {edge, edge, edge, edge};
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
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
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), self.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithRoundedCornerRadius:(CGFloat)radius AndSize:(CGSize)sizeToFit
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

+ (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit radius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor
{
    CGFloat halfBorderWidth = borderWidth / 2;
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    //设置上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框大小
    CGContextSetLineWidth(context, borderWidth);
    //边框颜色
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    //矩形填充颜色
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    CGFloat height = sizeToFit.height;
    CGFloat width = sizeToFit.width;
    
    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);  // 右下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius); // 左上角
    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius); // 右上角
    
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

- (UIImage *)scaleToSize:(CGSize)size
{
    return [self scaleToSize:size withContentMode:UIViewContentModeScaleToFill];
}

- (UIImage *)scaleToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    [self drawInRect:[self convertRect:(CGRect){0.0f, 0.0f, self.size} withContentMode:contentMode]];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
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

+ (UIImage *)fastImageWithData:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    return [self decodeImage:image];
}

+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [self decodeImage:image];
}

#pragma maek - private method

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode
{
    if (self.size.width == rect.size.width && self.size.height == rect.size.height) {
        return rect;
    }
    
    CGRect retRect = rect;
    switch (contentMode) {
        case UIViewContentModeScaleToFill: {
            break;
        }
        case UIViewContentModeScaleAspectFit: {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
                
            } else {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            }
            retRect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                                 rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                                 imageSize.width, imageSize.height);
            break;
        }
        case UIViewContentModeScaleAspectFill: {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
                
            } else {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            }
            retRect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                                 rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                                 imageSize.width, imageSize.height);
            break;
        }
        case UIViewContentModeRedraw: {
            break;
        }
        case UIViewContentModeCenter: {
            retRect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                                 rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTop: {
            retRect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                                 rect.origin.y,
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottom: {
            retRect = CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                                 rect.origin.y + floor(rect.size.height - self.size.height),
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeLeft: {
            retRect = CGRectMake(rect.origin.x,
                                 rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeRight: {
            retRect = CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                                 rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopLeft: {
            retRect = CGRectMake(rect.origin.x,
                                 rect.origin.y,
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopRight: {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y,
                              self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomLeft: {
            retRect = CGRectMake(rect.origin.x,
                                 rect.origin.y + floor(rect.size.height - self.size.height),
                                 self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomRight: {
            retRect = CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                                 rect.origin.y + (rect.size.height - self.size.height),
                                 self.size.width, self.size.height);
            break;
        }
    }
    return retRect;
}

+ (UIImage *)decodeImage:(UIImage *)image
{
    if(image == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointMake(0, 0)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
