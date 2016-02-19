//
//  NSDate+LYZExtension.h
//  AppProject
//
//  Created by 刘育哲 on 15/4/8.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 !!!:
 NSDateFormatter和NSCalendar初始化很慢，并且设置一个NSDateFormatter的速度差不多和创建新的一样慢！
 
 解决办法：
 可以通过重用对象来解决（添加属性或创建静态变量）。
 性能调优见 http://blog.jobbole.com/37984/ 13.重用大开销对象 & 25.避免日期格式转换
 
 */
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
@property (nonatomic, assign, readonly) BOOL leapMonth; /**< 是否闰月 */

#pragma mark - compare date

- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isSameYear:(NSDate *)aDate;

- (BOOL)isThisMonth;
- (BOOL)isNextMonth;
- (BOOL)isLastMonth;
- (BOOL)isSameMonth:(NSDate *)aDate;

- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isSameDay:(NSDate *)aDate;

- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameWeek:(NSDate *)aDate;
- (BOOL)isWeekend; /**< 是否周末 */
- (BOOL)isWorkday; /**< 是否工作日 */

- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;

#pragma mark - adjust date

- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

#pragma mark - date format

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyl;
/** @param format e.g. @"yyyy-MM-dd EEEE HH:mm:ss" */
- (NSString *)stringWithFormat:(NSString *)format;
/** @param format e.g. @"yyyy-MM-dd EEEE HH:mm:ss" */
- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
/** @return e.g. "2010-07-09T16:13:30+12:00" */
- (NSString *)stringWithISOFormat;

/** @param format e.g. @"yyyy-MM-dd EEEE HH:mm:ss" */
+ (NSDate *)dateWithString:(NSString *)dataString format:(NSString *)format;
/** @param format e.g. @"yyyy-MM-dd EEEE HH:mm:ss" */
+ (NSDate *)dateWithString:(NSString *)dataString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
/** @return e.g. "2010-07-09T16:13:30+12:00" */
+ (NSDate *)dateWithISOFormatString:(NSString *)dataString;

@end
