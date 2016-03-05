//
//  UIImagePickerController+LYZExtension.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/3/3.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

@import AVFoundation;

#import "UIImagePickerController+LYZExtension.h"

@implementation UIImagePickerController (LYZExtension)

+ (BOOL)photoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)cameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)savedPhotosAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

+ (BOOL)supportTakingPhotos
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (BOOL)supportPickVideosFromPhotoLibrary
{
    return [self supportsMedia:(__bridge NSString *)kUTTypeMovie
                      sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)supportPickPhotosFromPhotoLibrary
{
    return [self supportsMedia:(__bridge NSString *)kUTTypeImage
                      sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

#pragma mark - private method

+ (BOOL)supportsMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType
{
    __block BOOL result = NO;
    if ([mediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:mediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
    
}

@end
