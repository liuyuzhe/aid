//
//  LYZMathMethod.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 余弦 */
CG_INLINE CGFloat LYZCGFloatCos(CGFloat x)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)cos(x);
#else
    return (CGFloat)cosf(x);
#endif
}

/** 绝对值 */
CG_INLINE CGFloat LYZCGFloatAbs(CGFloat x)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)fabs(x);
#else
    return (CGFloat)fabsf(x);
#endif
}

/** x的y次方 */
CG_INLINE CGFloat LYZCGFloatPow(CGFloat x, CGFloat y)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)pow(x, y);
#else
    return (CGFloat)powf(x, y);
#endif
}

/** 平方根 */
CG_INLINE CGFloat LYZCGFloatSqrt(CGFloat x)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)sqrt(x);
#else
    return (CGFloat)sqrtf(x);
#endif
}

/** 向上取整 */
CG_INLINE CGFloat LYZCGFloatCeil(CGFloat x)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)ceil(x);
#else
    return (CGFloat)ceilf(x);
#endif
}

/** 向下取整 */
CG_INLINE CGFloat LYZCGFloatFloor(CGFloat x)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)floor(x);
#else
    return (CGFloat)floorf(x);
#endif
}

/** 四舍五入 */
CG_INLINE CGFloat LYZCGFloatRound(CGFloat x)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)round(x);
#else
    return (CGFloat)roundf(x);
#endif
}

/** 以参数y的符号（正或负）返回参数x */
CG_INLINE CGFloat LYZCGFloatCopysign(CGFloat x, CGFloat y)
{
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)copysign(x, y);
#else
    return (CGFloat)copysignf(x, y);
#endif
}

/** CGFloat阈值 */
CG_EXTERN CGFloat LYZBoundFloat(CGFloat value, CGFloat min, CGFloat max);
/** NSInteger阈值 */
CG_EXTERN NSInteger LYZBoundInt(NSInteger value, NSInteger min, NSInteger max);
/** CGFloat判等 */
CG_EXTERN BOOL LYZCGFloatEqual(CGFloat value1, CGFloat value2);

