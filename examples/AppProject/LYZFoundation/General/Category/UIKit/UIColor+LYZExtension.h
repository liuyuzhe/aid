//
//  UIColor+LYZExtension.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef LYZColorRGB
#define LYZColorRGB(r, g, b)     [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0f]
#endif
#ifndef LYZColorRGBA
#define LYZColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
#endif

#ifndef LYZColorHSB
#define LYZColorHSB(h, s, b)     [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:1.0f]
#endif
#ifndef LYZColorHSBA
#define LYZColorHSBA(h, s, b, a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]
#endif

#ifndef LYZColorHSL
#define LYZColorHSL(h, s, l)     [UIColor colorWithHue:(h) saturation:(s) lightness:(l) alpha:1.0f]
#endif
#ifndef LYZColorHSLA
#define LYZColorHSLA(h, s, l, a) [UIColor colorWithHue:(h) saturation:(s) lightness:(l) alpha:(a)]
#endif

#ifndef LYZColorCMYK
#define LYZColorCMYK(c, m, y, k)     [UIColor colorWithCyan:(c) magenta:(m) yellow:(y) black:(k) alpha:1.0f]
#endif
#ifndef LYZColorCMYKA
#define LYZColorCMYKA(c, m, y, k, a) [UIColor colorWithCyan:(c) magenta:(m) yellow:(y) black:(k) alpha:(a)]
#endif

#ifndef LYZColorHex
#define LYZColorHexString(hex) [UIColor colorWithHexString:(@#hex)]
#endif


CG_EXTERN void LYZRGBToHSB(CGFloat r, CGFloat g, CGFloat b,
                        CGFloat *h, CGFloat *s, CGFloat *v);
CG_EXTERN void LYZHSBToRGB(CGFloat h, CGFloat s, CGFloat v,
                        CGFloat *r, CGFloat *g, CGFloat *b);
CG_EXTERN void LYZRGBToHSL(CGFloat r, CGFloat g, CGFloat b,
                       CGFloat *h, CGFloat *s, CGFloat *l);
CG_EXTERN void LYZHSLToRGB(CGFloat h, CGFloat s, CGFloat l,
                       CGFloat *r, CGFloat *g, CGFloat *b);
CG_EXTERN void LYZHSBToHSL(CGFloat h, CGFloat s, CGFloat b,
                       CGFloat *hh, CGFloat *ss, CGFloat *ll);
CG_EXTERN void LYZHSLToHSB(CGFloat h, CGFloat s, CGFloat l,
                       CGFloat *hh, CGFloat *ss, CGFloat *bb);
CG_EXTERN void LYZRGBToCMYK(CGFloat r, CGFloat g, CGFloat b,
                  CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k);
CG_EXTERN void LYZCMYKToRGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
                  CGFloat *r, CGFloat *g, CGFloat *b);



@interface UIColor (LYZExtension)

@property (nonatomic, assign, readonly) CGFloat red;
@property (nonatomic, assign, readonly) CGFloat green;
@property (nonatomic, assign, readonly) CGFloat blue;

@property (nonatomic, assign, readonly) CGFloat hue;
@property (nonatomic, assign, readonly) CGFloat saturation;
@property (nonatomic, assign, readonly) CGFloat brightness;

@property (nonatomic, assign, readonly) CGFloat alpha;
@property (nonatomic, assign, readonly) CGColorSpaceModel colorSpaceModel;

#pragma mark -

+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha;
+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha;

/** @param hex 格式：0xRRGGBB */
+ (UIColor *)colorWithRGB:(uint32_t)hex;
/** @param hex 格式：0xRRGGBB */
+ (UIColor *)colorWithRGB:(uint32_t)hex alpha:(CGFloat)alpha;
/** @param hex 格式：0xRRGGBBAA */
+ (UIColor *)colorWithRGBA:(uint32_t)hex;
/** @param hexSting 格式：#RGB \ #ARGB \ #RRGGBB \ #AARRGGBB */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

#pragma mark -

/** @return 格式：0xRRGGBB */
- (uint32_t)rgbValue;
/** @return 格式：0xRRGGBBAA */
- (uint32_t)rgbaValue;

/** @return 格式：@"RRGGBB" */
- (NSString *)hexString;
/** @return 格式：@"AARRGGBB" */
- (NSString *)hexStringWithAlpha;

- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha;
- (BOOL)getCyan:(CGFloat *)cyan
        magenta:(CGFloat *)magenta
         yellow:(CGFloat *)yellow
          black:(CGFloat *)black
          alpha:(CGFloat *)alpha;

@end
