//
//  LYZApplicationShared.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/13.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

@import CoreLocation;
#import <Foundation/Foundation.h>

@interface LYZApplicationShared : NSObject

+ (BOOL)hasAppWithScheme:(NSString *)scheme;

+ (BOOL)openAppWithScheme:(NSString *)scheme;
+ (BOOL)openAppWithScheme:(NSString *)scheme appStoreId:(NSString *)appStoreId;
+ (BOOL)openAppWithScheme:(NSString *)scheme withPath:(NSString *)path;
+ (BOOL)openAppWithScheme:(NSString *)scheme appStoreId:(NSString *)appStoreId andPath:(NSString *)path;

@end



@interface LYZMailApp : NSObject

@property (nonatomic, copy) NSString *recipient; /**< 收件人 */
@property (nonatomic, copy) NSString *cc; /**< 抄送 */
@property (nonatomic, copy) NSString *bcc; /**< 密送 */
@property (nonatomic, copy) NSString *subject; /**< 主题 */
@property (nonatomic, copy) NSString *body; /**< 内容 */

+ (instancetype)mailApp;

@end


@interface LYZApplicationShared (SystemApplication)

+ (BOOL)safariWithURL:(NSURL *)url;

#pragma mark -

+ (BOOL)appStoreWithAppId:(NSString *)appId;

#pragma mark -

+ (BOOL)phoneWithNumber:(NSString *)phoneNumber;
+ (BOOL)phoneConfirmWithNumber:(NSString *)phoneNumber;

#pragma mark -

+ (BOOL)facetimeWithNumber:(NSString *)phoneNumber;
+ (BOOL)facetimeConfirmWithNumber:(NSString *)phoneNumber;

+ (BOOL)facetimeWithEmail:(NSString *)email;
+ (BOOL)facetimeConfirmWithEmail:(NSString *)email;

#pragma mark -

+ (BOOL)SMSWithNumber:(NSString *)phoneNumber;

+ (BOOL)SMSWithEmail:(NSString *)email;

#pragma mark -

+ (BOOL)mailWithMailAppDefine:(LYZMailApp *)mailApp;

#pragma mark -

+ (BOOL)appleMaps;

+ (BOOL)appleMapWithQuery:(NSString *)query withNear:(NSString *)near;
+ (BOOL)appleMapAtLocation:(CLLocationCoordinate2D)location;

+ (BOOL)appleMapDirectionsFromSourceAddress:(NSString *)srcAddr
                              toDestAddress:(NSString *)destAddr;

#pragma mark -

/** 设置无线局域网 */
+ (BOOL)openSetWifi;
/** 设置蓝牙 */
+ (BOOL)openSetBluetooth;
/** 设置蜂窝移动数据 */
+ (BOOL)openSetCellular;

/** 设置通知 */
+ (BOOL)openSetNotifications;
/** 设置隐私 */
+ (BOOL)openSetPrivacy;
/** 设置定位服务 */
+ (BOOL)openSetLocation;

/** 设置Touch ID */
+ (BOOL)openSetTouchId;
/** 设置iCloud */
+ (BOOL)openSetICloud;

@end
