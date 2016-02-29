//
//  AidDiscoverThemeTable.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverThemeTable.h"

@implementation AidDiscoverThemeTable

#pragma mark - CTPersistanceTableProtocol

- (NSString *)tableName
{
    return @"discoverTheme";
}

- (NSString *)databaseName
{
    return @"DiscoverThemeDatabase.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey" : @"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name" : @"TEXT NOT NULL",
             @"describe" : @"TEXT",
             @"imageName" : @"TEXT",
             @"themeType" : @"TEXT",
             @"createTime" : @"INTEGER",
             @"storeState" : @"INTEGER",
             @"watchCount" : @"INTEGER",
             @"praiseCount" : @"INTEGER",
             @"storeCount" : @"INTEGER",
             };
}

- (Class)recordClass
{
    return [AidDiscoverThemeRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

- (void)modifyDatabaseName:(NSString *)databaseName
{
    
}

@end
