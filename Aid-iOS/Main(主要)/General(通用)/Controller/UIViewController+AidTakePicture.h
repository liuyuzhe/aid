//
//  UIViewController+AidTakePicture.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AidFinishPicker)(UIImage * chooseImage);

@interface UIViewController (AidTakePicture) <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

- (void)imagePickerAction;

#warning 回调实现存在问题
@property (nonatomic, copy) AidFinishPicker didFinishPicker; /**< 完成图片选取 */

@end
