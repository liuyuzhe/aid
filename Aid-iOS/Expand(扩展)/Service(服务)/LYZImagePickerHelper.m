//
//  LYZImagePickerHelper.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/29.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZImagePickerHelper.h"

@interface LYZImagePickerHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) LYZImagePickerCompledBlock didFinishPicker;

@end


@implementation LYZImagePickerHelper

#pragma mark - public method

- (void)showOnViewController:(UIViewController *)viewController withSourceType:(UIImagePickerControllerSourceType)sourceType compled:(LYZImagePickerCompledBlock)compled
{
    if (! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        compled(nil, nil);
        return;
    }
    
    self.didFinishPicker = [compled copy];

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES; // 允许修改的图片
    imagePicker.delegate = self;

    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePicker.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [viewController presentViewController:imagePicker animated:YES completion:nil];
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

@end
