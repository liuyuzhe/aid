//
//  NSObject+LYZTypeConvert.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/11.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LYZTypeConvert)

- (NSInteger)asInteger;
- (float)asFloat;
- (BOOL)asBool;

- (NSNumber *)asNSNumber;
- (NSString *)asNSString;
- (NSDate *)asNSDate;
- (NSData *)asNSData;

- (NSArray *)asNSArray;
- (NSMutableArray *)asNSMutableArray;
- (NSDictionary *)asNSDictionary;
- (NSMutableDictionary *)asNSMutableDictionary;

@end
