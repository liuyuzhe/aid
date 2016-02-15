//
//  AidTaskTable.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidTaskTable.h"

@implementation AidTaskTable

#pragma mark - CTPersistanceTableProtocol

- (NSString *)tableName
{
    return @"task";
}

- (NSString *)databaseName
{
    return @"TaskDatabase.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey" : @"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name" : @"TEXT NOT NULL",
             @"startTime" : @"INTEGER",
             @"endTime" : @"INTEGER",
             @"alarmTime" : @"INTEGER",
             @"repeat" : @"INTEGER",
             @"note" : @"TEXT",
             @"completeState" : @"INTEGER",
             @"priority" : @"INTEGER",
             @"themeID" : @"INTEGER",
             };
}

- (Class)recordClass
{
    return [AidTaskRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

- (void)modifyDatabaseName:(NSString *)databaseName
{
    
}

@end
