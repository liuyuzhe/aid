//
//  LYZDateAndTimeValueTransformer.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/7.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZDateAndTimeValueTransformer.h"

@implementation LYZDateValueTrasformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSDate class]]){
        NSDate * date = (NSDate *)value;
        return [date stringWithFormat:@"yyyy-MM-dd EEE"];
    }
    return nil;
}

@end



@implementation LYZTimeValueTrasformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSDate class]]){
        NSDate * date = (NSDate *)value;
        return [date stringWithFormat:@"HH:mm:ss"];
;
    }
    return nil;
}

@end


@implementation LYZDateAndTimeValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSDate class]]){
        NSDate * date = (NSDate *)value;
        return [date stringWithFormat:@"yyyy-MM-dd EEE HH:mm"];
    }
    return nil;
}

@end
