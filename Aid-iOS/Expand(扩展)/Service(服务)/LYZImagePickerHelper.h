//
//  LYZImagePickerHelper.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/29.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LYZImagePickerCompletedBlock)(UIImage *image, NSDictionary *info);

@interface LYZImagePickerHelper : NSObject

- (void)showOnViewController:(UIViewController *)viewController withSourceType:(UIImagePickerControllerSourceType)sourceType completed:(LYZImagePickerCompletedBlock)completed;

- (void)showOnViewController:(UIViewController *)viewController completed:(LYZImagePickerCompletedBlock)completed;

@end
