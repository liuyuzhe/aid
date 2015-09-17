//
//  NSString+LYZCodeSecurity.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSString+LYZCodeSecurity.h"
#import "NSData+LYZCodeSecurity.h"

@implementation NSString (LYZCodeSecurity)

- (NSString *)md5String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSData *)md5Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Data];
}

- (NSString *)sha1String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (NSData *)sha1Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Data];
}

@end
