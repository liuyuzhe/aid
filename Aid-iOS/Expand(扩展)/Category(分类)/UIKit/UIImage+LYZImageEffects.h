//
//  UIImage+LYZImageEffects.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/10.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
 
 仅在支持iOS7时使用。因为在iOS8之后，可以使用 UIVisualEffect 类实现模糊效果。
 
 */
@interface UIImage (LYZImageEffects)

- (UIImage*)imageByApplyingLightEffect;
- (UIImage*)imageByApplyingExtraLightEffect;
- (UIImage*)imageByApplyingDarkEffect;
- (UIImage*)imageByApplyingTintEffectWithColor:(UIColor *)tintColor;

//| ----------------------------------------------------------------------------
//! Applies a blur, tint color, and saturation adjustment to @a inputImage,
//! optionally within the area specified by @a maskImage.
//!
//! @param  blurRadius
//!         The radius of the blur in points.
//! @param  tintColor
//!         An optional UIColor object that is uniformly blended with the
//!         result of the blur and saturation operations.  The alpha channel
//!         of this color determines how strong the tint is.
//! @param  saturationDeltaFactor
//!         A value of 1.0 produces no change in the resulting image.  Values
//!         less than 1.0 will desaturation the resulting image while values
//!         greater than 1.0 will have the opposite effect.
//! @param  maskImage
//!         If specified, @a inputImage is only modified in the area(s) defined
//!         by this mask.  This must be an image mask or it must meet the
//!         requirements of the mask parameter of CGContextClipToMask.
- (UIImage*)imageByApplyingBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
