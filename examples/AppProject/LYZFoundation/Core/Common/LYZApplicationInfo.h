//
//  LYZApplicationInfo.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/12.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYZApplicationInfo : NSObject

#pragma mark - LYZApplicationInfo

/** 程序包名称（短） */
+ (NSString *)appName;
/** 显示名称（长） */
+ (NSString *)appDsiplayName;
/** 发布版本号 @return e.g. "1.2.0"  */
+ (NSString *)appVersion; //
/** 内部版本号 @return e.g. "123" */
+ (NSString *)appBuildVersion;
/** 标识符 @return e.g. "com.test.MyApp" */
+ (NSString *)appIdentifier;
/** 程序包路径 @return e.g. ~/MyApp.app */
+ (NSString *)bundlePath;
/** 资源文件路径 @return e.g. ~/MyApp.app */
+ (NSString *)resourcePath;
/** 可执行文件路径 @return e.g. ~/MyApp.app/MyApp */
+ (NSString *)executablePath;

#pragma mark -

/** app已用内存 */
+ (CGFloat)MBytesOfMemoryUsage;
/** app已用CPU @return 0 .. 1.0 */
+ (CGFloat)cpuUsage;

@end
