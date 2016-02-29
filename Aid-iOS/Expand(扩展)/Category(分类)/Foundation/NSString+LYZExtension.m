//
//  NSString+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/15.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+LYZExtension.h"

@implementation NSString (LYZExtension)

- (NSString *)trimHeadWhitespace
{
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];
    for (i = 0; i < [self length]; i++)
    {
        if (! [cs characterIsMember:[self characterAtIndex: i]]) {
            break;
        }
    }
    return [self substringFromIndex: i];
}

- (NSString *)trimTailWhitespace
{
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];
    for (i = [self length] -1; i >= 0; i--)
    {
        if (! [cs characterIsMember:[self characterAtIndex: i]] ) {
            break;
        }
    }
    return [self substringToIndex: (i + 1)];
}

- (NSString *)trimBothWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimHeadWhitespaceAndNewline
{
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (i = 0; i < [self length]; i++)
    {
        if (! [cs characterIsMember:[self characterAtIndex: i]]) {
            break;
        }
    }
    return [self substringFromIndex: i];
}

- (NSString *)trimTailWhitespaceAndNewline
{
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (i = [self length] -1; i >= 0; i--)
    {
        if (! [cs characterIsMember:[self characterAtIndex: i]] ) {
            break;
        }
    }
    return [self substringToIndex: (i + 1)];
}

- (NSString *)trimBothWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}

#pragma mark -

- (BOOL)equals:(NSString *)str
{
    return [self compare:str] == NSOrderedSame;
}

@end
