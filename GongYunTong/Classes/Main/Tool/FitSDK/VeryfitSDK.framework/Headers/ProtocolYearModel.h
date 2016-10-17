//
//  ProtocolYearModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolYearModel : JKDBModel


@property (nonatomic, copy) NSString *year_number;             //年，如2014

@property (nonatomic, assign) NSInteger year_total_steps;         // 当年的总步数
@property (nonatomic, assign) NSInteger year_total_calories;      // 当年的总卡路里
@property (nonatomic, assign) NSInteger year_total_distance ;     // 当年的总路程
@property (nonatomic, assign) NSInteger year_total_sleep ;        // 当年的总睡眠时间

@property (nonatomic, assign) NSInteger daily_steps;             // 日均步数.
@property (nonatomic, assign) NSInteger daily_calories;          // 日均卡路里.
@property (nonatomic, assign) NSInteger daily_distance;          // 日均里程.

@property (nonatomic, assign) NSInteger daily_sleep;             // 日均睡眠.
@property (nonatomic, assign) NSInteger daily_deep_sleep;         // 日均深睡.
@property (nonatomic, assign) NSInteger daily_shallow_sleep;      // 日均浅睡.
@property (nonatomic, assign) NSInteger daily_waking_sleep;       // 日均清醒.
@property (nonatomic, assign) NSInteger daily_start_sleep;        // 日均入睡时间.
@property (nonatomic, assign) NSInteger daily_end_sleep;          // 日均醒来时间.

@property (nonatomic,copy) NSString *smart_device_id;


@property (nonatomic,strong) NSMutableArray *monthDataArray;

@property (nonatomic,strong) NSMutableArray *show_month_sport_data_array;
@property (nonatomic,strong) NSMutableArray *show_month_sleep_data_array;
@property (nonatomic,strong) NSMutableArray *show_month_deep_data_array;
@property (nonatomic,strong) NSMutableArray *show_month_shallow_data_array;
@property (nonatomic,strong) NSMutableArray *show_month_silent_data_array;


@end
