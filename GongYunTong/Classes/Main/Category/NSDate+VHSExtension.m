//
//  NSDate+VHSExtension.m
//  VHealth1.6
//
//  Created by vhsben on 16/7/4.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "NSDate+VHSExtension.h"

@implementation NSDate (VHSExtension)

- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

+ (NSInteger)pastOfNowWithPastDateStr:(NSString *)pastDateStr {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComps = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour| NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *lastComps = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[VHSCommon dateWithDateStr:pastDateStr]];
    
    NSInteger pastDays = nowComps.day - lastComps.day;
    if (nowComps.month == lastComps.month && nowComps.year == lastComps.year) {
        // 同月
        pastDays = nowComps.day - lastComps.day;
    } else if (nowComps.month != lastComps.month) {
        // 跨月
        NSUInteger days = [self daysForMonthDateStr:pastDateStr];
        pastDays = nowComps.day + days - lastComps.day;
    }
    return pastDays;
}

+ (NSString *)yyyymmddByPastDays:(NSInteger)pastDays {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    cmps.day = cmps.day - pastDays;
    
    NSString *dateStr = [VHSCommon getYYYYmmddDate:[calendar dateFromComponents:cmps]];
    return dateStr;
}

+ (NSString *)ymdByPastDay:(NSInteger)pastDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    cmps.day = cmps.day - pastDays;
    NSDate *date = [calendar dateFromComponents:cmps];
    NSString *ymd = [VHSCommon getYmdFromDate:date];
    return ymd;
}

+ (NSString *)yyyymmddhhmmssPastDay:(NSInteger)pastDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    cmps.day = cmps.day - pastDays;
    NSDate *date = [calendar dateFromComponents:cmps];
    NSString *ymd = [VHSCommon getDate:date];
    return ymd;
}

+ (NSDate *)designatDate:(NSString *)date hour:(NSString *)hour minute:(NSString *)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[VHSCommon dateWithDateStr:date]];
    cmps.hour = hour.integerValue;
    cmps.minute = minute.integerValue;
    NSDate *designatDate = [calendar dateFromComponents:cmps];
    return designatDate;
}

+ (NSString *)yyyymmddhhmmssEndByPastDays:(NSInteger)pastDays {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    cmps.day = cmps.day - pastDays;
    cmps.hour = 23;
    cmps.minute = 59;
    cmps.second = 59;
    
    NSString *dateStr = [VHSCommon getDate:[calendar dateFromComponents:cmps]];
    return dateStr;
}

+ (NSString *)yyyymmddhhmmssStartByPastDays:(NSInteger)pastDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    cmps.day = cmps.day - pastDays;
    cmps.hour = 0;
    cmps.minute = 0;
    cmps.second = 1;
    
    NSString *dateStr = [VHSCommon getDate:[calendar dateFromComponents:cmps]];
    return dateStr;
}

+ (NSString *)mmddhhmmWithDateStr:(NSString *)dateStr {
    NSDate *date = [VHSCommon dateWithDateStr:dateStr];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM/dd HH:mm";
    return [fmt stringFromDate:date];
}

+ (BOOL)time:(NSString *)time onBetweenStartTime:(NSString *)startTime toEndTime:(NSString *)endTime {
    NSDate *oriTime = [VHSCommon dateWithDateStr:time];
    NSDate *stime = [VHSCommon dateWithDateStr:startTime];
    NSDate *etime = [VHSCommon dateWithDateStr:endTime];
    
    NSTimeInterval oriInterval = [[NSDate date] timeIntervalSinceDate:oriTime];
    NSTimeInterval sInterval = [[NSDate date] timeIntervalSinceDate:stime];
    NSTimeInterval eInterval = [[NSDate date] timeIntervalSinceDate:etime];
    
    BOOL flag = NO;
    
    if (oriInterval > sInterval && oriInterval < eInterval) {
        flag = YES;
    }
    
    return flag;
}

+ (NSUInteger)daysForMonthDateStr:(NSString *)dateStr {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[VHSCommon dateWithDateStr:dateStr]];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

@end
