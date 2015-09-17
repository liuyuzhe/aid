//
//  NSData+LYZCodeSecurity.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>

#import "NSData+LYZCodeSecurity.h"

@implementation NSData (LYZCodeSecurity)

- (NSString *)md2String
{
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD2_DIGEST_LENGTH; ++ i) {
        [output appendFormat:@"%02x", result[i]];
    }
    
    return output;
}

- (NSData *)md2Data
{
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD2_DIGEST_LENGTH];
}

- (NSString *)md4String
{
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD4_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD4_DIGEST_LENGTH; ++ i) {
        [output appendFormat:@"%02x", result[i]];
    }
    
    return output;
}

- (NSData *)md4Data
{
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_MD4_DIGEST_LENGTH];
}

- (NSString *)md5String
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++ i) {
        [output appendFormat:@"%02x", result[i]];
    }
    
    return output;
}

- (NSData *)md5Data
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

#pragma mark -

- (NSString *)sha1String
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSData *)sha1Data
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}


- (NSString *)sha224String
{
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSData *)sha224Data
{
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSData *)sha256Data
{
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha384String
{
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSData *)sha384Data
{
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSData *)sha512Data
{
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    
    return [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark -

- (NSString *)hmacMD5StringWithKey:(NSString *)key {
    return [self hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSData *)hmacMD5DataWithKey:(NSData *)key {
    return [self hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
    return [self hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSData *)hmacSHA1DataWithKey:(NSData *)key {
    return [self hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSString *)hmacSHA224StringWithKey:(NSString *)key {
    return [self hmacStringUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

- (NSData *)hmacSHA224DataWithKey:(NSData *)key {
    return [self hmacDataUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
    return [self hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSData *)hmacSHA256DataWithKey:(NSData *)key {
    return [self hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSString *)hmacSHA384StringWithKey:(NSString *)key {
    return [self hmacStringUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

- (NSData *)hmacSHA384DataWithKey:(NSData *)key {
    return [self hmacDataUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
    return [self hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

- (NSData *)hmacSHA512DataWithKey:(NSData *)key {
    return [self hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

#pragma mark -

- (NSString *)crc32String
{
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    
    return [NSString stringWithFormat:@"%08x", (uint32_t)result];
}

- (uint32_t)crc32
{
    uLong result = crc32(0, self.bytes, (uInt)self.length);
    
    return (uint32_t)result;
}

#pragma mark -

- (NSData *)aes256EncryptWithKey:(NSData *)key iv:(NSData *)iv
{
    if (key.length != 16 && key.length != 24 && key.length != 32) {
        return nil;
    }
    if (iv.length != 16 && iv.length != 0) {
        return nil;
    }
    
    NSData *result = nil;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          self.bytes,
                                          self.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

- (NSData *)aes256DecryptWithkey:(NSData *)key iv:(NSData *)iv
{
    if (key.length != 16 && key.length != 24 && key.length != 32) {
        return nil;
    }
    if (iv.length != 16 && iv.length != 0) {
        return nil;
    }
    
    NSData *result = nil;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          self.bytes,
                                          self.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

#pragma mark - LYZCodeSecurity helper

- (NSString *)hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key
{
    size_t size;

    switch (alg) {
        case kCCHmacAlgMD5:
            size = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA1:
            size = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            size = CC_SHA224_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            size = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            size = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            size = CC_SHA512_DIGEST_LENGTH;
            break;
            
        default:
            return nil;
    }
    
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), self.bytes, self.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSData *)hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key
{
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5:
            size = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA1:
            size = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            size = CC_SHA224_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            size = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            size = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            size = CC_SHA512_DIGEST_LENGTH;
            break;
            
        default:
            return nil;
    }
    
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    
    return [NSData dataWithBytes:result length:size];
}

@end
