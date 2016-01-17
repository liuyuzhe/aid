//
//  AidThemeTable.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidThemeTable.h"

@implementation AidThemeTable

#pragma mark - CTPersistanceTableProtocol

- (NSString *)tableName
{
    return @"theme";
}

- (NSString *)databaseName
{
    return @"ThemeDatabase.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey" : @"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name" : @"TEXT NOT NULL",
             @"describe" : @"TEXT",
             @"imageName" : @"TEXT",
             @"createTime" : @"INTEGER",
             @"praiseState" : @"INTEGER",
             @"watchCount" : @"INTEGER",
             @"praiseCount" : @"INTEGER",
             @"storeCount" : @"INTEGER",
             };
}

- (Class)recordClass
{
    return [AidThemeRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

- (void)modifyDatabaseName:(NSString *)databaseName
{
    
}

@end
