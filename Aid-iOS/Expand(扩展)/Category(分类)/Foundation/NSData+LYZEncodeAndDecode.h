//
//  NSData+LYZEncodeAndDecode.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
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
@interface NSData (LYZEncodeAndDecode)

- (NSString *)utf8String;
- (NSString *)base64String;

- (NSString *)binaryToHexString;
+ (NSData *)dataWithHexString:(NSString *)hexString;

#pragma mark -

/** 解压 */
- (NSData *)gzipInflate;
/** 压缩 level：Z_DEFAULT_COMPRESSION (-1) */
- (NSData *)gzipDeflate;
/**
 * 压缩
 @param level
 Z_NO_COMPRESSION         0
 Z_BEST_SPEED             1
 Z_BEST_COMPRESSION       9
 Z_DEFAULT_COMPRESSION  (-1)
 */
- (NSData *)gzipDeflateWithCompressLevel:(NSInteger)level;

/** 解压 */
- (NSData *)zlibInflate;
/** 压缩 level：Z_DEFAULT_COMPRESSION (-1) */
- (NSData *)zlibDeflate;
/**
 * 压缩
 @param level
 Z_NO_COMPRESSION         0
 Z_BEST_SPEED             1
 Z_BEST_COMPRESSION       9
 Z_DEFAULT_COMPRESSION  (-1)
 */
- (NSData *)zlibDeflateWithCompressLevel:(NSInteger)level;

@end
