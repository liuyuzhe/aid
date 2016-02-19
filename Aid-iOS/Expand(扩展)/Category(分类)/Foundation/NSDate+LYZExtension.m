//
//  NSDate+LYZExtension.m
//  AppProject
//
//  Created by 刘育哲 on 15/4/8.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSDate+LYZExtension.h"
#import "LYZMathMacro.h"

@implementation NSDate (LYZExtension)

- (NSInteger)year
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)day
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)hour
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)minute
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)second
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

- (NSInteger)nanosecond
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].nanosecond;
}

- (NSInteger)weekday
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}

- (NSInteger)weekdayOrdinal
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self].weekdayOrdinal;
}

- (NSInteger)quarter
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self].quarter;
}

- (NSInteger)weekOfMonth
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self].weekOfMonth;
}

- (NSInteger)weekOfYear
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self].weekOfYear;
}

- (NSInteger)yearForWeekOfYear
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self].yearForWeekOfYear;
}

- (BOOL)leapMonth
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self].leapMonth;
}

#pragma mark - relative date

+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysFromNow:-1];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days
{
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours
{
    return [[NSDate date] dateByAddingHours:hours];
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes
{
    return [[NSDate date] dateByAddingMinutes:minutes];
}

#pragma mark - compare date

- (BOOL)isThisYear
{
    return [self isSameYear:[NSDate date]];
}

- (BOOL)isNextYear
{
    return self.year == ([NSDate date].year + 1);
}

- (BOOL)isLastYear
{
    return self.year == ([NSDate date].year - 1);
}

- (BOOL)isSameYear:(NSDate *)aDate
{
    return self.year == aDate.year;
}

- (BOOL)isThisMonth
{
    return [self isSameMonth:[NSDate date]];
}

- (BOOL)isNextMonth
{
    NSDate *newDate = [self dateByAddingMonths:1];
    return [self isSameMonth:newDate];
}

- (BOOL)isLastMonth
{
    NSDate *newDate = [self dateByAddingMonths:-1];
    return [self isSameMonth:newDate];
}

- (BOOL)isSameMonth:(NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    
    NSDateComponents *dateCmps = [calendar components:unit fromDate:aDate];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return ((selfCmps.year == dateCmps.year) &&
            (selfCmps.month == dateCmps.month));
}

- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

- (BOOL)isTomorrow
{
    NSDate *newDate = [self dateByAddingDays:1];
    return [self isSameDay:newDate];
}

- (BOOL)isYesterday
{
    NSDate *newDate = [self dateByAddingDays:-1];
    return [self isSameDay:newDate];
}

- (BOOL)isSameDay:(NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dateCmps = [calendar components:unit fromDate:aDate];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return ((selfCmps.year == dateCmps.year) &&
            (selfCmps.month == dateCmps.month) &&
            (selfCmps.day == dateCmps.day));
}

- (BOOL)isThisWeek
{
    return [self isSameWeek:[NSDate date]];
}

- (BOOL)isNextWeek
{
    NSDate *newDate = [self dateByAddingWeeks:1];
    return [self isSameWeek:newDate];
}

- (BOOL)isLastWeek
{
    NSDate *newDate = [self dateByAddingWeeks:-1];
    return [self isSameWeek:newDate];
}

- (BOOL)isSameWeek:(NSDate *)aDate
{
    if (self.weekOfMonth != aDate.weekOfMonth) {
        return NO;
    }
    
    return fabs([self timeIntervalSinceDate:aDate]) < LYZSecondsInWeek;
}

- (BOOL)isWeekend
{
    NSInteger weekday = self.weekday;
    if (weekday == 1 || weekday == 7) {
        return YES;
    }
    return NO;
}

- (BOOL)isWorkday
{
    return ! [self isWeekend];
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate
{
    return [self earlierDate:aDate] == self;
}

- (BOOL)isLaterThanDate:(NSDate *)aDate
{
    return [self laterDate:aDate] == self;
}

#pragma mark - adjust date

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = years;
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = months;
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekOfYear = weeks;
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + LYZSecondsInDay * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + LYZSecondsInHour * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + LYZSecondsInMinute * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return newDate;
}

#pragma mark - date format

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.locale = [NSLocale currentLocale];

    return [formatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    
    if (timeZone) {
        formatter.timeZone = timeZone;
    }
    if (locale) {
        formatter.locale = locale;
    }
    
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithISOFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)dataString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;

    return [formatter dateFromString:dataString];
}

+ (NSDate *)dateWithString:(NSString *)dataString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    
    if (timeZone) {
        formatter.timeZone = timeZone;
    }
    if (locale) {
        formatter.locale = locale;
    }
    
    return [formatter dateFromString:dataString];
}

+ (NSDate *)dateWithISOFormatString:(NSString *)dataString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    return [formatter dateFromString:dataString];
}

@end
