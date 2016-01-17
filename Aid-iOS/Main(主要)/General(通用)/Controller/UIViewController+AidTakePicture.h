//
//  UIViewController+AidTakePicture.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AidTakePicture) <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

- (void)imagePickerAction;

@end
