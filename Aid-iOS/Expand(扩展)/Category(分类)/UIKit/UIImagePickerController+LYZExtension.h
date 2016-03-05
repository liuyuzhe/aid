//
//  UIImagePickerController+LYZExtension.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/3/3.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (LYZExtension)

/** 相册是否可用 */
+ (BOOL)photoLibraryAvailable;
/** 相机是否可用 */
+ (BOOL)cameraAvailable;
/** 保存相册是否可用 */
+ (BOOL)savedPhotosAvailable;

/** 是否支持拍照权限 */
+ (BOOL)supportTakingPhotos;
/** 是否支持获取相册视频权限 */
+ (BOOL)supportPickVideosFromPhotoLibrary;
/** 是否支持获取相册图片权限 */
+ (BOOL)supportPickPhotosFromPhotoLibrary;

@end
