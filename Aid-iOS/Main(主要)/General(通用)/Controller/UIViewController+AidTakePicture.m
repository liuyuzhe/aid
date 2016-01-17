//
//  UIViewController+AidTakePicture.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

@import AVFoundation;
#import "UIViewController+AidTakePicture.h"

@implementation UIViewController (AidTakePicture)

#pragma mark - public methods

- (void)imagePickerAction
{
    if ([LYZDeviceInfo systemVersionGreaterThan:@"7.0"]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的“设置-隐私-相机”中允许访问相机。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    if ([LYZDeviceInfo systemVersionGreaterThan:@"8.0"]) {
        [self showUploadActionSheetForIOS8];
    }
    else {
        [self showUploadActionSheetBeforeIOS8];
    }
}

#pragma mark -

- (void)showUploadActionSheetForIOS8
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self showImagePickerWithButtonIndex:0];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self showImagePickerWithButtonIndex:1];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showUploadActionSheetBeforeIOS8
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照" , @"从相册选择" ,nil];
    
    [actionSheet showFromRect:self.view.bounds
                       inView:self.navigationController.view
                     animated:YES];
}

- (void)showImagePickerWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if(buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera; // 相机
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 相册
    }
    
    imagePicker.allowsEditing = YES; // 允许修改的图片
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [self showImagePickerWithButtonIndex:buttonIndex];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage]; // 修改后的图片
        if (! editedImage) {
            editedImage = [info valueForKey:UIImagePickerControllerOriginalImage]; // 原始图片
        }
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
