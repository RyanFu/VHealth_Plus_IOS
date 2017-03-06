//
//  NSDate+VHSExtension.h
//  VHealth1.6
//
//  Created by vhsben on 16/7/4.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (VHSExtension)

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断某个时间点距离当前时间过去几天 0：当天 1:昨天 2:前天 3:大前天 依次往下 -1:表示不在一个年份
 *
 *  @param pastDateStr 过去的某个时间点
 *
 *  @return 返回一个数值 表示过去了几天
 */
+ (NSInteger)pastOfNowWithPastDateStr:(NSString *)pastDateStr;

/**
 *  获取格式为yyyymmdd格式的过去时间字符串，通过传入一个距离当前时间点几天值
 *
 *  @param pastDays 过去的天数
 *
 *  @return 时间字符串
 */
+ (NSString *)yyyymmddByPastDays:(NSInteger)pastDays;

/**
 *  获取格式为yyyy-MM-dd格式的过去时间字符串，通过传入一个距离当前时间点几天值
 *
 *  @param pastDays 过去的天数
 *
 *  @return 时间字符串
 */
+ (NSString *)ymdByPastDay:(NSInteger)pastDays;
/**
 *  获取格式为yyyy-MM-dd HH:mm:ss格式的过去时间字符串，通过传入一个距离当前时间点几天值
 *
 *  @param pastDays 过去的天数
 *
 *  @return 时间字符串
 */
+ (NSString *)yyyymmddhhmmssPastDay:(NSInteger)pastDays;

/**
 *  获取格式为yyyy-MM-dd HH:mm:dd 的一天的开始 如 2016-02-01 23:59:59
 *
 *  @param pastDays 过去的天数
 *
 *  @return 时间字符串
 */
+ (NSString *)yyyymmddhhmmssEndByPastDays:(NSInteger)pastDays;

/**
 *  获取格式为yyyy-MM-dd HH:mm:dd 的一天开始  如2016-02-01 00:00:01
 *
 *  @param pastDays 过去的天数
 *
 *  @return 时间字符串
 */
+ (NSString *)yyyymmddhhmmssStartByPastDays:(NSInteger)pastDays;

/**
 *  获取格式为mmdd/hhmm
 *
 *  @return 返回格式为MM/dd HH:mm字符串
 */
+ (NSString *)mmddhhmmWithDateStr:(NSString *)dateStr;

/**
 *  判断一个时间是否在指定时间段中
 *
 *  @param time      时间点
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return bool值
 */
+ (BOOL)time:(NSString *)time onBetweenStartTime:(NSString *)startTime toEndTime:(NSString *)endTime;

/// 通过给定日期，获取出指定时间点
+ (NSDate *)designatDate:(NSString *)date hour:(NSString *)hour minute:(NSString *)minute;
@end
