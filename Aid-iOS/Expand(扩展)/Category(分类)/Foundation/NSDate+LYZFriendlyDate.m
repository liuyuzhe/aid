//
//  NSDate+LYZFriendlyDate.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "NSDate+LYZFriendlyDate.h"
#import "NSDate+LYZExtension.h"

@implementation NSDate (LYZFriendlyDate)

- (NSString *)friendlyDateString
{
    if (self.isToday) {
        return @"今天";
    }
    else if (self.isYesterday) {
        return @"昨天";
    }
    else if (self.isTomorrow) {
        return @"明天";
    }
    else if (self.isThisYear) {
        return [self stringWithFormat:@"MM-dd EEE"];
    }
    else if (self.isLastYear) {
        return [self stringWithFormat:@"去年 MM-dd EEE"];
    }
    else if (self.isNextYear) {
        return [self stringWithFormat:@"明年 MM-dd EEE"];
    }
    else {
        return [self stringWithFormat:@"yyyy-MM-dd EEE"];
    }
}

- (NSString *)friendlyDateTimeString
{
    if (self.isToday) {
        return [self stringWithFormat:@"今天 HH:mm"];
    }
    else if (self.isYesterday) {
        return [self stringWithFormat:@"昨天 HH:mm"];
    }
    else if (self.isTomorrow) {
        return [self stringWithFormat:@"明天 HH:mm"];
    }
    else if (self.isThisYear) {
        return [self stringWithFormat:@"MM-dd EEE HH:mm"];
    }
    else if (self.isLastYear) {
        return [self stringWithFormat:@"去年 MM-dd EEE HH:mm"];
    }
    else if (self.isNextYear) {
        return [self stringWithFormat:@"明年 MM-dd EEE HH:mm"];
    }
    else {
        return [self stringWithFormat:@"yyyy-MM-dd EEE HH:mm"];
    }
}

@end
