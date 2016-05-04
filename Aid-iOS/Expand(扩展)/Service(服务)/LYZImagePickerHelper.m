//
//  LYZImagePickerHelper.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/29.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZImagePickerHelper.h"
#import "UIImagePickerController+LYZExtension.h"

@interface LYZImagePickerHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, copy) LYZImagePickerCompletedBlock didFinishPicker;

@end


@implementation LYZImagePickerHelper

#pragma mark - public methods

- (void)showOnViewController:(UIViewController *)viewController withSourceType:(UIImagePickerControllerSourceType)sourceType completed:(LYZImagePickerCompletedBlock)completed
{
    if (! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        completed(nil, nil);
        return;
    }
    
    self.currentVC = viewController;
    self.didFinishPicker = [completed copy];

    [self showImagePickerWithSourceType:sourceType];
}

- (void)showOnViewController:(UIViewController *)viewController completed:(LYZImagePickerCompletedBlock)completed
{
    if (! [UIImagePickerController supportTakingPhotos]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"请在设备的“设置-隐私-相机”中允许访问相机"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController presentViewController:alert animated: YES completion: nil];
        });
        
        completed(nil, nil);
        return;
    }

    self.currentVC = viewController;
    self.didFinishPicker = [completed copy];

    if ([LYZDeviceInfo systemVersionGreaterThan:@"8.0"]) {
        [self showUploadActionSheet];
    }
}

- (void)showUploadActionSheet
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.currentVC presentViewController:alert animated: YES completion: nil];
    });
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePicker.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePicker.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    }

    [self.currentVC presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage]; // 修改后的图片
    if (! editedImage) {
        editedImage = [info valueForKey:UIImagePickerControllerOriginalImage]; // 原始图片
    }
    
    if (self.didFinishPicker)
    {
        self.didFinishPicker(editedImage, info);
    }
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didFinishPicker = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didFinishPicker = nil;
    }];
}

#pragma mark - getters and setters

- (UIImagePickerController *)imagePicker
{
    if (! _imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = YES; // 允许修改的图片
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (UIViewController *)currentVC
{
    if (! _currentVC) {
        _currentVC = [[UIViewController alloc] init];
    }
    return _currentVC;
}

@end
