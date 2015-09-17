//
//  UIView+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "UIView+LYZExtension.h"
#import "LYZDeviceInfo.h"

@implementation UIView (LYZExtension)

- (UIImage *)snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    if ([LYZDeviceInfo systemVersionGreaterThanOrEqualTo:@"7.0"]) {
        // more (about 15x) faster than `renderInContext`.  available from iOS7.
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snap;
}

@end
