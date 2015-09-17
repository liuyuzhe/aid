//
//  NSString+LYZCodeSecurity.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYZCodeSecurity)

- (NSString *)md5String;
- (NSData *)md5Data;

- (NSString *)sha1String;
- (NSData *)sha1Data;

@end
