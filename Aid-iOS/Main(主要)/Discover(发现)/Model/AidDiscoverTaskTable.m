//
//  AidDiscoverTaskTable.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidDiscoverTaskTable.h"

@implementation AidDiscoverTaskTable

- (NSString *)tableName
{
    return @"discoverTask";
}

- (NSString *)databaseName
{
    return @"DiscoverTaskDatabase.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey" : @"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name" : @"TEXT NOT NULL",
             @"startTime" : @"INTEGER",
             @"endTime" : @"INTEGER",
             @"alarmTime" : @"INTEGER",
             @"repeat" : @"TEXT",
             @"note" : @"TEXT",
             @"priority" : @"INTEGER",
             @"themeID" : @"INTEGER",
             };
}

- (Class)recordClass
{
    return [AidDiscoverTaskRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

- (void)modifyDatabaseName:(NSString *)databaseName
{
    
}

@end
