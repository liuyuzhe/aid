//
//  NSString+LYZRegexMatch.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYZRegexMatch)

- (BOOL)isMobilephone; // 手机号码
- (BOOL)isTelephone; // 座机号码

- (BOOL)isUserName; // 用户名 5-20 alphabet
- (BOOL)isChineseName; // 中文名 2-16 chinese
- (BOOL)isChineseUserName; // 昵称 3-20 alphabet and chinese
- (BOOL)isPassword; // 密码 6-20 alphabet

- (BOOL)isEmail; // 邮箱
- (BOOL)isUrl; // 网址
- (BOOL)isIPAddress; // IP地址
- (BOOL)isIdentityCard; // 身份证号

@end
