//
//  LYZMathMethod.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZMathMethod.h"

CGFloat LYZBoundFloat(CGFloat value, CGFloat min, CGFloat max)
{
    if (max < min) {
        max = min;
    }
    CGFloat bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

NSInteger LYZBoundInt(NSInteger value, NSInteger min, NSInteger max)
{
    if (max < min) {
        max = min;
    }
    NSInteger bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

BOOL LYZCGFloatEqual(CGFloat value1, CGFloat value2)
{
    return LYZCGFloatAbs(value1 - value2) < 1e-6;
}

