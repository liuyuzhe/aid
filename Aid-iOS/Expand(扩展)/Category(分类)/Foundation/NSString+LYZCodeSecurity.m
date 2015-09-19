//
//  NSString+LYZCodeSecurity.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSString+LYZCodeSecurity.h"
#import "NSData+LYZCodeSecurity.h"

@implementation NSString (LYZCodeSecurity)

- (NSString *)md2String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md2String];
}

- (NSData *)md2Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md2Data];
}

- (NSString *)md4String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md4String];
}

- (NSData *)md4Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md4Data];
}

- (NSString *)md5String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSData *)md5Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Data];
}

#pragma mark -

- (NSString *)sha1String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (NSData *)sha1Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Data];
}

- (NSString *)sha224String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224String];
}

- (NSData *)sha224Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224Data];
}

- (NSString *)sha256String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256String];
}

- (NSData *)sha256Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256Data];
}

- (NSString *)sha384String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384String];
}

- (NSData *)sha384Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384Data];
}

- (NSString *)sha512String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512String];
}

- (NSData *)sha512Data
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512Data];
}

#pragma mark -

- (NSString *)hmacMD5StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            hmacMD5StringWithKey:key];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            hmacSHA1StringWithKey:key];
}

- (NSString *)hmacSHA224StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            hmacSHA224StringWithKey:key];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            hmacSHA256StringWithKey:key];
}

- (NSString *)hmacSHA384StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            hmacSHA384StringWithKey:key];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            hmacSHA512StringWithKey:key];
}

#pragma mark -

- (NSString *)crc32String;
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] crc32String];
}

- (uint32_t)crc32;
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] crc32];
}

@end
