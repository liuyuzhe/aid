//
//  NSNumber+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/15.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSNumber+LYZExtension.h"
#import "NSString+LYZExtension.h"

@implementation NSNumber (LYZExtension)

+ (NSNumber *)numberWithString:(NSString *)string
{
    NSString *str = [[string trimBothWhitespaceAndNewline] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) {
        sign = 1;
    }
    else if ([str hasPrefix:@"-0x"]) {
        sign = -1;
    }
    
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc) {
            return [NSNumber numberWithLong:((long)num * sign)];
        }
        else {
            return nil;
        }
    }
    
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end
