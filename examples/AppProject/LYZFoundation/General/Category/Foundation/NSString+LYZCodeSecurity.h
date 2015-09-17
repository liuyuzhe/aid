//
//  NSString+LYZCodeSecurity.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYZCodeSecurity)

- (NSString *)md2String;
- (NSData *)md2Data;
- (NSString *)md4String;
- (NSData *)md4Data;
- (NSString *)md5String;
- (NSData *)md5Data;

#pragma mark -

- (NSString *)sha1String;
- (NSData *)sha1Data;
- (NSString *)sha224String;
- (NSData *)sha224Data;
- (NSString *)sha256String;
- (NSData *)sha256Data;
- (NSString *)sha384String;
- (NSData *)sha384Data;
- (NSString *)sha512String;
- (NSData *)sha512Data;

#pragma mark -

- (NSString *)hmacMD5StringWithKey:(NSString *)key;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

#pragma mark -

- (NSString *)crc32String;
- (uint32_t)crc32;

@end
