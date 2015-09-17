//
//  NSDate+LYZExtension.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/8.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LYZExtension)

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger nanosecond;
@property (nonatomic, assign, readonly) NSInteger weekday;
@property (nonatomic, assign, readonly) NSInteger weekdayOrdinal;
@property (nonatomic, assign, readonly) NSInteger quarter;
@property (nonatomic, assign, readonly) NSInteger weekOfMonth;
@property (nonatomic, assign, readonly) NSInteger weekOfYear;
@property (nonatomic, assign, readonly) NSInteger yearForWeekOfYear;
@property (nonatomic, assign, readonly) BOOL leapMonth;

@end
