//
//  NSDate+WHExtension.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/8/2.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "NSDate+WHExtension.h"

@implementation NSDate (WHExtension)

- (NSDateComponents *)intervalToNow
{
    return [self intervalToDate:[NSDate date]];
}

- (NSDateComponents *)intervalToDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear
    | NSCalendarUnitMonth
    | NSCalendarUnitDay
    | NSCalendarUnitHour
    | NSCalendarUnitMinute
    | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self toDate:date options:0];
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar calendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day == selfCmps.day;
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}
@end
