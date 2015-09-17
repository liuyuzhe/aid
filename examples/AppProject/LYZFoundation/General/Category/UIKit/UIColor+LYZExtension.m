//
//  UIColor+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "UIColor+LYZExtension.h"
#import "LYZMathMethod.h"

void LYZRGBToHSB(CGFloat r, CGFloat g, CGFloat b,
                 CGFloat *h, CGFloat *s, CGFloat *v)
{
    r = LYZBoundFloat(r, 0, 1);
    g = LYZBoundFloat(g, 0, 1);
    b = LYZBoundFloat(b, 0, 1);
    
    CGFloat max, min, delta;
    max = fmax(r, fmax(g, b));
    min = fmin(r, fmin(g, b));
    delta = max - min;
    
    *v = max;               // Brightness
    if (delta == 0) {       // No Saturation, so Hue is undefined (achromatic)
        *h = *s = 0;
        return;
    }
    *s = delta / max;       // Saturation
    
    if (r == max) {
        *h = (g - b) / delta / 6;
    } // color between y & m
    else if (g == max) {
        *h = (2 + (b - r) / delta) / 6;
    } // color between c & y
    else {
        *h = (4 + (r - g) / delta) / 6;
    } // color between m & c
    
    if (*h < 0) {
        *h += 1;
    }
}

void LYZHSBToRGB(CGFloat h, CGFloat s, CGFloat v,
                 CGFloat *r, CGFloat *g, CGFloat *b)
{
    h = LYZBoundFloat(h, 0, 1);
    s = LYZBoundFloat(s, 0, 1);
    v = LYZBoundFloat(v, 0, 1);
    
    if (s == 0) {
        *r = *g = *b = v; // No Saturation, so Hue is undefined (Achromatic)
    }
    else {
        int sextant;
        CGFloat f, p, q, t;
        if (h == 1) {
            h = 0;
        }
        h *= 6;
        sextant = floor(h);
        f = h - sextant;
        p = v * (1 - s);
        q = v * (1 - s * f);
        t = v * (1 - s * (1 - f));
        switch (sextant) {
            case 0:
                *r = v; *g = t; *b = p;
                break;
            case 1:
                *r = q; *g = v; *b = p;
                break;
            case 2:
                *r = p; *g = v; *b = t;
                break;
            case 3:
                *r = p; *g = q; *b = v;
                break;
            case 4:
                *r = t; *g = p; *b = v;
                break;
            case 5:
                *r = v; *g = p; *b = q;
                break;
        }
    }
}

void LYZRGBToHSL(CGFloat r, CGFloat g, CGFloat b,
                CGFloat *h, CGFloat *s, CGFloat *l)
{
    r = LYZBoundFloat(r, 0, 1);
    g = LYZBoundFloat(g, 0, 1);
    b = LYZBoundFloat(b, 0, 1);
    
    CGFloat max, min, delta, sum;
    max = fmaxf(r, fmaxf(g, b));
    min = fminf(r, fminf(g, b));
    delta = max - min;
    sum = max + min;
    
    *l = sum / 2;           // Lightness
    if (delta == 0) {       // No Saturation, so Hue is undefined (achromatic)
        *h = *s = 0;
        return;
    }
    *s = delta / (sum < 1 ? sum : 2 - sum);             // Saturation
    if (r == max) {
        *h = (g - b) / delta / 6;
    } // color between y & m
    else if (g == max) {
        *h = (2 + (b - r) / delta) / 6;
    } // color between c & y
    else {
        *h = (4 + (r - g) / delta) / 6;
    } // color between m & y
    
    if (*h < 0) {
        *h += 1;
    }
}

void LYZHSLToRGB(CGFloat h, CGFloat s, CGFloat l,
                CGFloat *r, CGFloat *g, CGFloat *b)
{
    h = LYZBoundFloat(h, 0, 1);
    s = LYZBoundFloat(s, 0, 1);
    l = LYZBoundFloat(l, 0, 1);
    
    if (s == 0) { // No Saturation, Hue is undefined (achromatic)
        *r = *g = *b = l;
        return;
    }
    
    CGFloat q;
    q = (l <= 0.5) ? (l * (1 + s)) : (l + s - (l * s));
    if (q <= 0) {
        *r = *g = *b = 0.0;
    }
    else {
        *r = *g = *b = 0;
        int sextant;
        CGFloat m, sv, fract, vsf, mid1, mid2;
        m = l + l - q;
        sv = (q - m) / q;
        if (h == 1) {
            h = 0;
        }
        h *= 6.0;
        sextant = h;
        fract = h - sextant;
        vsf = q * sv * fract;
        mid1 = m + vsf;
        mid2 = q - vsf;
        switch (sextant) {
            case 0:
                *r = q; *g = mid1; *b = m;
                break;
            case 1:
                *r = mid2; *g = q; *b = m;
                break;
            case 2:
                *r = m; *g = q; *b = mid1;
                break;
            case 3:
                *r = m; *g = mid2; *b = q;
                break;
            case 4:
                *r = mid1; *g = m; *b = q;
                break;
            case 5:
                *r = q; *g = m; *b = mid2;
                break;
        }
    }
}

void LYZHSBToHSL(CGFloat h, CGFloat s, CGFloat b,
                CGFloat *hh, CGFloat *ss, CGFloat *ll)
{
    h = LYZBoundFloat(h, 0, 1);
    s = LYZBoundFloat(s, 0, 1);
    b = LYZBoundFloat(b, 0, 1);
    
    *hh = h;
    *ll = (2 - s) * b / 2;
    if (*ll <= 0.5) {
        *ss = (s) / ((2 - s));
    }
    else {
        *ss = (s * b) / (2 - (2 - s) * b);
    }
}

void LYZHSLToHSB(CGFloat h, CGFloat s, CGFloat l,
                CGFloat *hh, CGFloat *ss, CGFloat *bb)
{
    h = LYZBoundFloat(h, 0, 1);
    s = LYZBoundFloat(s, 0, 1);
    l = LYZBoundFloat(l, 0, 1);
    
    *hh = h;
    if (l <= 0.5) {
        *bb = (s + 1) * l;
        *ss = (2 * s) / (s + 1);
    }
    else {
        *bb = l + s * (1 - l);
        *ss = (2 * s * (1 - l)) / *bb;
    }
}

void LYZRGBToCMYK(CGFloat r, CGFloat g, CGFloat b,
                 CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k)
{
    r = LYZBoundFloat(r, 0, 1);
    g = LYZBoundFloat(g, 0, 1);
    b = LYZBoundFloat(b, 0, 1);
    
    *c = 1 - r;
    *m = 1 - g;
    *y = 1 - b;
    *k = fmin(*c, fmin(*m, *y));
    
    if (*k == 1) {
        *c = *m = *y = 0;   // Pure black
    }
    else {
        *c = (*c - *k) / (1 - *k);
        *m = (*m - *k) / (1 - *k);
        *y = (*y - *k) / (1 - *k);
    }
}

void LYZCMYKToRGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
                 CGFloat *r, CGFloat *g, CGFloat *b)
{
    c = LYZBoundFloat(c, 0, 1);
    m = LYZBoundFloat(m, 0, 1);
    y = LYZBoundFloat(y, 0, 1);
    k = LYZBoundFloat(k, 0, 1);
    
    *r = (1 - c) * (1 - k);
    *g = (1 - m) * (1 - k);
    *b = (1 - y) * (1 - k);
}



@implementation UIColor (LYZExtension)

- (CGFloat)red
{
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)green
{
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blue
{
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)hue
{
    CGFloat h = 0, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return h;
}

- (CGFloat)saturation
{
    CGFloat h, s = 0, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return s;
}

- (CGFloat)brightness
{
    CGFloat h, s, b = 0, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return b;
}

- (CGFloat)alpha
{
    return CGColorGetAlpha(self.CGColor);
}

- (CGColorSpaceModel)colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

#pragma mark -

+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha
{
    saturation *= (lightness < 0.5) ? lightness : 1.0 - lightness;
    
    return [self colorWithHue:hue
                   saturation:2.0 * saturation / (lightness + saturation)
                   brightness:lightness + saturation
                        alpha:alpha];
}

+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha {
    CGFloat r, g, b;
    LYZCMYKToRGB(cyan, magenta, yellow, black, &r, &g, &b);
    
    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:alpha];
}

+ (UIColor *)colorWithRGB:(uint32_t)hex
{
    return [UIColor colorWithRGB:hex alpha:1.0];
}

+ (UIColor *)colorWithRGB:(uint32_t)hex alpha:(CGFloat)alpha;
{
    return [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0f
                           green:((hex & 0xFF00) >> 8) / 255.0f
                            blue:(hex & 0xFF) / 255.0f
                           alpha:alpha];
}

+ (UIColor *)colorWithRGBA:(uint32_t)hex;
{
    return [UIColor colorWithRed:((hex & 0xFF000000) >> 24) / 255.0f
                           green:((hex & 0xFF0000) >> 16) / 255.0f
                            blue:((hex & 0xFF00) >> 8) / 255.0f
                           alpha:(hex & 0xFF) / 255.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch([colorString length])
    {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
            
        default:
            return nil;
            break;
    }
    
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}

#pragma mark -

- (uint32_t)rgbValue
{
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)rgbaValue
{
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (NSString *)hexString
{
    return [self hexStringWithAlpha:NO];
}

- (NSString *)hexStringWithAlpha
{
    return [self hexStringWithAlpha:YES];
}

- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha
{
    CGFloat h, s, b, a;
    if (! [self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return NO;
    }
    
    LYZHSBToHSL(h, s, b, hue, saturation, lightness);
    *alpha = a;
    
    return YES;
}

- (BOOL)getCyan:(CGFloat *)cyan
        magenta:(CGFloat *)magenta
         yellow:(CGFloat *)yellow
          black:(CGFloat *)black
          alpha:(CGFloat *)alpha
{
    CGFloat r, g, b, a;
    if (! [self getRed:&r green:&g blue:&b alpha:&a]) {
        return NO;
    }
    
    LYZRGBToCMYK(r, g, b, cyan, magenta, yellow, black);
    *alpha = a;
    
    return YES;
}

#pragma mark - LYZExtension helper

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    
    return hexComponent / 255.0f;
}

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha
{
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    }
    else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        NSString * alpha = [NSString stringWithFormat:@"%02lx", (unsigned long)(self.alpha * 255.0 + 0.5)];
        hex = [alpha stringByAppendingString:hex];
    }
    
    return hex;
}

@end
