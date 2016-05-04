//
//  NSString+LYZEncodeAndDecode.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYZEncodeAndDecode)

- (NSData *)base64EncodeData; // base64加密,封包处理
- (NSString *)base64EncodeString; // base64加密,封包处理

- (NSData *)base64DecodeData; // base64解密,封包处理
- (NSString *)base64DecodeString; // base64解密,封包处理

#pragma mark -

- (NSString *)stringByURLEncode;
- (NSString *)stringByURLEncode:(NSStringEncoding)encoding;

- (NSString *)stringByURLDecode;
- (NSString *)stringByURLDecode:(NSStringEncoding)encoding;

- (NSString *)URLQueryStringAppendDictionary:(NSDictionary *)dict;
- (NSDictionary *)URLQueryDictionary;
- (NSDictionary *)URLQueryDictionary:(NSStringEncoding)encoding;

#pragma mark -

- (NSString *)stringByAddingHTMLEscapes;
- (NSString *)stringByReplacingHTMLEscapes;

@end
