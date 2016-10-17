//
//  ProtocolWeekModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolWeekModel : NSObject

@property (nonatomic, assign) NSInteger week_number;         // 第几周
@property (nonatomic, assign) NSInteger year_number;         // 年，如2014


@property (nonatomic, assign) NSInteger week_total_steps;     // 本周的总步数
@property (nonatomic, assign) NSInteger week_total_calories;  // 本周的总卡路里
@property (nonatomic, assign) NSInteger week_total_distance ; // 本周的总路程
@property (nonatomic, assign) NSInteger week_total_sleep;     // 本周的总睡眠时间.

@property (nonatomic, assign) NSInteger daily_steps;         // 日均步数.
@property (nonatomic, assign) NSInteger daily_calories;      // 日均卡路里.
@property (nonatomic, assign) NSInteger daily_distance;      // 日均里程.

@property (nonatomic, assign) NSInteger daily_sleep;          // 日均睡眠.
@property (nonatomic, assign) NSInteger daily_deep_sleep;     // 日均深睡.
@property (nonatomic, assign) NSInteger daily_shallow_sleep;  // 日均浅睡.
@property (nonatomic, assign) NSInteger daily_waking_sleep;   // 日均清醒.
@property (nonatomic, assign) NSInteger daily_start_sleep;    // 日均入睡时间.
@property (nonatomic, assign) NSInteger daily_end_sleep;      // 日均醒来时间.


@property (nonatomic,strong) NSMutableArray *show_sport_data_array;
@property (nonatomic,strong) NSMutableArray *show_sleep_data_array;
@property (nonatomic,strong) NSMutableArray *show_deep_data_array;
@property (nonatomic,strong) NSMutableArray *show_shallow_data_array;
@property (nonatomic,strong) NSMutableArray *show_silent_data_array;


@property (nonatomic, strong) NSMutableDictionary *sportDic;
@property (nonatomic,strong) NSMutableDictionary *sleepDic;
@property (nonatomic,strong) NSMutableDictionary *heartDic;
@property (nonatomic,strong) NSMutableArray *dateArray;

- (NSString *)showDates;
@end
