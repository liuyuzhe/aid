//
//  NSData+LYZCodeSecurity.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 !!!: 
 引入 <zlib.h> Link Error: Undefined symbols for ...
 
 解决办法：
 xcode中点 TARGETS /Build Phases / Link Binary With Libraies 中点“+”后选择
 添加libz.dylib类库
 
 */
@interface NSData (LYZCodeSecurity)

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
- (NSData *)hmacMD5DataWithKey:(NSData *)key;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSData *)hmacSHA1DataWithKey:(NSData *)key;
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;
- (NSData *)hmacSHA224DataWithKey:(NSData *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSData *)hmacSHA256DataWithKey:(NSData *)key;
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;
- (NSData *)hmacSHA384DataWithKey:(NSData *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;
- (NSData *)hmacSHA512DataWithKey:(NSData *)key;

#pragma mark -

- (NSString *)crc32String;
- (uint32_t)crc32;

#pragma mark -

- (NSData *)aes256EncryptWithKey:(NSData *)key iv:(NSData *)iv;
- (NSData *)aes256DecryptWithkey:(NSData *)key iv:(NSData *)iv;

@end
