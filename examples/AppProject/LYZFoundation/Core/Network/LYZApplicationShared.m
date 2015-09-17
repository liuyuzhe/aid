//
//  LYZApplicationShared.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/13.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LYZApplicationShared.h"
#import "NSString+LYZRegexMatch.h"
#import "NSString+LYZEncodeAndDecode.h"

@implementation LYZApplicationShared

+ (BOOL)hasAppWithScheme:(NSString *)scheme
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]];
}

+ (BOOL)openAppWithScheme:(NSString *)scheme
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
}

+ (BOOL)openAppWithScheme:(NSString *)scheme appStoreId:(NSString *)appStoreId
{
    return [self openAppWithScheme:scheme appStoreId:appStoreId andPath:nil];
}

+ (BOOL)openAppWithScheme:(NSString *)scheme withPath:(NSString *)path
{
    return [self openAppWithScheme:scheme appStoreId:nil andPath:path];
}

+ (BOOL)openAppWithScheme:(NSString *)scheme appStoreId:(NSString *)appStoreId andPath:(NSString *)path
{
    BOOL didOpen = NO;
    
    NSString *urlPath = scheme;
    
    if (path) {
        urlPath = [urlPath stringByAppendingFormat:@"%@", path];
    }
    
    didOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlPath]];
    
    if (! didOpen && appStoreId) {
        didOpen = [self appStoreWithAppId:appStoreId];
    }
    
    return didOpen;
}

@end



@implementation LYZMailApp

+ (instancetype)mailApp;
{
    // 采用 [[self class] alloc] 时，如果类派生了子类，产生的将是类型相同的子类对象，而不是基类对象
    return [[[self class] alloc] init];
}

@end


@implementation LYZApplicationShared (SystemApplication)

+ (BOOL)safariWithURL:(NSURL *)url
{
    return [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -

+ (BOOL)appStoreWithAppId:(NSString *)appId
{
    NSString *urlPath = [@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=" stringByAppendingString:appId];
    
    return [self openAppWithScheme:urlPath];
}

#pragma mark -

+ (BOOL)phoneWithNumber:(NSString *)phoneNumber
{
    if (! [phoneNumber isMobilephone] || ! [phoneNumber isTelephone]) {
        return NO;
    }
    
    NSString *urlPath = [@"tel:" stringByAppendingString:phoneNumber];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)phoneConfirmWithNumber:(NSString *)phoneNumber
{
    if (! [phoneNumber isMobilephone] && ! [phoneNumber isTelephone]) {
        return NO;
    }
    
    NSString *urlPath = [@"telprompt:" stringByAppendingString:phoneNumber];
    return [self openAppWithScheme:urlPath];
}

#pragma mark -

+ (BOOL)facetimeWithNumber:(NSString *)phoneNumber
{
    if (! [phoneNumber isMobilephone]) {
        return NO;
    }
    
    NSString *urlPath = [@"facetime://" stringByAppendingString:phoneNumber];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)facetimeConfirmWithNumber:(NSString *)phoneNumber
{
    if (! [phoneNumber isMobilephone]) {
        return NO;
    }
    
    NSString *urlPath = [@"facetime-prompt://" stringByAppendingString:phoneNumber];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)facetimeWithEmail:(NSString *)email
{
    if (! [email isEmail]) {
        return NO;
    }
    
    NSString *urlPath = [@"facetime://" stringByAppendingString:email];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)facetimeConfirmWithEmail:(NSString *)email
{
    if (! [email isEmail]) {
        return NO;
    }
    
    NSString *urlPath = [@"facetime-prompt://" stringByAppendingString:email];
    return [self openAppWithScheme:urlPath];
}

#pragma mark -

+ (BOOL)SMSWithNumber:(NSString *)phoneNumber
{
    if (! [phoneNumber isMobilephone]) {
        return NO;
    }
    
    NSString *urlPath = [@"sms:" stringByAppendingString:phoneNumber];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)SMSWithEmail:(NSString *)email
{
    if (! [email isEmail]) {
        return NO;
    }
    
    NSString *urlPath = [@"sms:" stringByAppendingString:email];
    return [self openAppWithScheme:urlPath];
}

#pragma mark -

+ (BOOL)mailWithMailAppDefine:(LYZMailApp *)mailApp
{
    if (! [mailApp.recipient isEmail]) {
        return NO;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *urlPath = @"mailto:";
    
    urlPath = [urlPath stringByAppendingString:[mailApp.recipient stringByURLEncode]];
    
    if (mailApp.cc.length > 0) {
        [parameters setObject:mailApp.cc forKey:@"cc"];
    }
    if (mailApp.bcc.length > 0) {
        [parameters setObject:mailApp.bcc forKey:@"bcc"];
    }
    if (mailApp.subject.length > 0) {
        [parameters setObject:mailApp.subject forKey:@"subject"];
    }
    if (mailApp.body.length > 0) {
        [parameters setObject:mailApp.body forKey:@"body"];
    }
    
    urlPath = [urlPath URLQueryStringAppendDictionary:parameters];
    
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlPath]];
}

#pragma mark -

static NSString * const LYZAppSharedAppleMapsWithScheme = @"http://maps.apple.com/";

+ (BOOL)appleMaps
{
    NSString *urlPath = [LYZAppSharedAppleMapsWithScheme stringByAppendingString:@"?q"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)appleMapWithQuery:(NSString *)query withNear:(NSString *)near
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *urlPath = LYZAppSharedAppleMapsWithScheme;
    
    if (query.length > 0) {
        [parameters setObject:query forKey:@"q"];
    }
    else {
        return [self appleMaps];
    }

    if (near.length > 0) {
        [parameters setObject:near forKey:@"near"];
    }
    
    urlPath = [urlPath URLQueryStringAppendDictionary:parameters];
    
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)appleMapAtLocation:(CLLocationCoordinate2D)location;
{
    NSString *urlPath = [NSString stringWithFormat:@"?ll=%f,%f", location.latitude, location.longitude];
    urlPath = [LYZAppSharedAppleMapsWithScheme stringByAppendingString:urlPath];
    
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)appleMapDirectionsFromSourceAddress:(NSString *)srcAddr
                              toDestAddress:(NSString *)destAddr
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *urlPath = LYZAppSharedAppleMapsWithScheme;
    
    if (srcAddr.length > 0) {
        [parameters setObject:srcAddr forKey:@"saddr"];
    }
    
    if (destAddr.length > 0) {
        [parameters setObject:destAddr forKey:@"daddr"];
    }
    else {
        return [self appleMaps];
    }
    
    urlPath = [urlPath URLQueryStringAppendDictionary:parameters];
    
    return [self openAppWithScheme:urlPath];
}

#pragma mark -

static NSString * const LYZAppSharedSettingsWithScheme = @"prefs:root";

+ (BOOL)openSetWifi;
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=WIFI"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetBluetooth
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=Bluetooth"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetCellular
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=MOBILE_DATA_SETTINGS_ID"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetNotifications;
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=NOTIFICATIONS_ID"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetPrivacy;
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=Privacy"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetLocation;
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=LOCATION_SERVICES"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetTouchId
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=TOUCHID_PASSCODE"];
    return [self openAppWithScheme:urlPath];
}

+ (BOOL)openSetICloud;
{
    NSString *urlPath = [LYZAppSharedSettingsWithScheme stringByAppendingString:@"=BlCASTLEuetooth"];
    return [self openAppWithScheme:urlPath];
}

@end
