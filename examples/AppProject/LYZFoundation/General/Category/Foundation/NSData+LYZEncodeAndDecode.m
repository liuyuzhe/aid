//
//  NSData+LYZEncodeAndDecode.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <zlib.h>

#import "NSData+LYZEncodeAndDecode.h"

@implementation NSData (LYZEncodeAndDecode)

- (NSString *)utf8String
{
    if (! self.length) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)base64String
{
    if (! self.length) {
        return nil;
    }
    
    return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)binaryToHexString
{
    if (! self.length) {
        return nil;
    }

    NSUInteger length = self.length;
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *byte = self.bytes;
    for (int i = 0; i < length; i++, byte++) {
        [result appendFormat:@"%02X", *byte];
    }
    
    return [result copy];
}

+ (NSData *)dataWithHexString:(NSString *)hexString;
{
    if (! hexString.length) {
        return nil;
    }
    
    NSString *hexStr = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data = [NSMutableData data];
    const char *src = [hexStr UTF8String];
    unsigned long length = strlen(src);
    char byteChars[3] = {0};
    
    for (unsigned long i = 0; i + 1 < length; i +=2)
    {
        byteChars[0] = src[i];
        byteChars[1] = src[i+1];
        unsigned long wholeBytes = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeBytes length:1];
    }
    
    return data;
}

#pragma mark -

- (NSData *)gzipInflate
{
    if (! [self length]) {
        return self;
    }
    
    unsigned full_length = (unsigned)[self length];
    unsigned half_length = (unsigned)[self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)[self length];
    stream.next_in = (Bytef *)[self bytes];
    stream.total_out = 0;
    stream.avail_out = 0;
    
    if (inflateInit2(&stream, (15 + 32)) != Z_OK) {
        return nil;
    }
    
    while (! done) {
        // Make sure we have enough room and reset the lengths.
        if (stream.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy:half_length];
        }
        stream.next_out = [decompressed mutableBytes] + stream.total_out;
        stream.avail_out = (uInt)([decompressed length] - stream.total_out);
        
        // Inflate another chunk.
        status = inflate(&stream, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        }
        else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd(&stream) != Z_OK) {
        return nil;
    }
    
    // Set real length.
    if (done) {
        [decompressed setLength:stream.total_out];
        return [decompressed copy];
    }
    
    return nil;
}

- (NSData *)gzipDeflate;
{
    return [self gzipDeflateWithCompressLevel:Z_DEFAULT_COMPRESSION];
}

- (NSData *)gzipDeflateWithCompressLevel:(NSInteger)level
{
    if (! [self length]) {
        return self;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)[self length];
    stream.next_in = (Bytef *)[self bytes];
    stream.total_out = 0;
    stream.avail_out = 0;

    if (deflateInit2(&stream, level, Z_DEFLATED, (15 + 16), 8, Z_DEFAULT_STRATEGY) != Z_OK) {
        return nil;
    }
    
    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do {
        if (stream.total_out >= [compressed length]) {
            [compressed increaseLengthBy:16384];
        }
        
        stream.next_out = [compressed mutableBytes] + stream.total_out;
        stream.avail_out = (uInt)([compressed length] - stream.total_out);
        
        deflate(&stream, Z_FINISH);
    }
    while (stream.avail_out == 0);
    
    deflateEnd(&stream);
    
    [compressed setLength:stream.total_out];
    return [compressed copy];
}

- (NSData *)zlibInflate
{
    if (! [self length]) {
        return self;
    }
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData
                                   dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)[self length];
    stream.next_in = (Bytef *)[self bytes];
    stream.total_out = 0;
    stream.avail_out = 0;

    if (inflateInit(&stream) != Z_OK) {
        return nil;
    }
    
    while (! done) {
        // Make sure we have enough room and reset the lengths.
        if (stream.total_out >= [decompressed length])
            [decompressed increaseLengthBy:half_length];
        stream.next_out = [decompressed mutableBytes] + stream.total_out;
        stream.avail_out = (uInt)([decompressed length] - stream.total_out);
        
        // Inflate another chunk.
        status = inflate(&stream, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        }
        else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd(&stream) != Z_OK) {
        return nil;
    }
    
    // Set real length.
    if (done) {
        [decompressed setLength:stream.total_out];
        return [decompressed copy];
    }
    
    return nil;
}

- (NSData *)zlibDeflate
{
    return [self zlibDeflateWithCompressLevel:Z_DEFAULT_COMPRESSION];
}

- (NSData *)zlibDeflateWithCompressLevel:(NSInteger)level
{
    if (! [self length]) {
        return self;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)[self length];
    stream.next_in = (Bytef *)[self bytes];
    stream.total_out = 0;
    stream.avail_out = 0;
    
    if (deflateInit(&stream, level) != Z_OK) {
        return nil;
    }
    
    // 16K chuncks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do {
        if (stream.total_out >= [compressed length]) {
            [compressed increaseLengthBy:16384];
        }
        
        stream.next_out = [compressed mutableBytes] + stream.total_out;
        stream.avail_out = (uInt)([compressed length] - stream.total_out);
        
        deflate(&stream, Z_FINISH);
    }
    while (stream.avail_out == 0);
    
    deflateEnd(&stream);
    
    [compressed setLength:stream.total_out];
    return [compressed copy];
}

@end
