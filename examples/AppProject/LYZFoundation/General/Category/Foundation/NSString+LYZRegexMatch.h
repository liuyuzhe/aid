//
//  NSString+LYZRegexMatch.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYZRegexMatch)

/** 手机号码 */
- (BOOL)isMobilephone;
/** 座机号码 */
- (BOOL)isTelephone;

/** 用户名（5-20 alphabet） */
- (BOOL)isUserName;
/** 中文名（2-16 chinese） */
- (BOOL)isChineseName;
/** 昵称（3-20 alphabet and chinese） */
- (BOOL)isChineseUserName;
/** 密码（6-20 alphabet） */
- (BOOL)isPassword;

/** 邮箱 */
- (BOOL)isEmail;
/** 网址 */
- (BOOL)isUrl;
/** IP地址 */
- (BOOL)isIPAddress;
/** 身份证号 */
- (BOOL)isIdentityCard;

@end
