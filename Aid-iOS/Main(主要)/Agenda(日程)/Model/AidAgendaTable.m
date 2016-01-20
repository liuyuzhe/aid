//
//  AidAgendaTable.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidAgendaTable.h"

@implementation AidAgendaTable

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
    return [AidAgendaRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

- (void)modifyDatabaseName:(NSString *)databaseName
{
    
}

@end
