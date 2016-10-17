//
//  SleepDataModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/17.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
#import "protocol_health_resolve_sleep.h"


@interface SleepItem : JKDBModel
@property (nonatomic,assign) uint8_t sleep_status;               //睡眠状态
@property (nonatomic,assign) uint8_t durations;                  //深睡次数
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *sleep_data_id;

- (id)initWith:(struct ble_sync_sleep_item)item;
@end
@interface ProtocolSleepDataModel : JKDBModel
@property (nonatomic,copy) NSString *itmes_count;

@property (nonatomic,strong) NSArray *SleepItemArray;
@property (nonatomic,copy) NSString *date;

@property (nonatomic,copy) NSString *smart_device_id;

/*
 sleephead
 */
@property (nonatomic,assign) uint8_t end_time_hour;               //睡眠结束时间[小时]
@property (nonatomic,assign) uint8_t end_time_minute;             //睡眠结束时间[分钟]
@property (nonatomic,assign) uint16_t total_minute;               //睡眠时长
/*
 sleephead1
 */
@property (nonatomic,assign) uint8_t light_sleep_count;            //浅睡眠次数
@property (nonatomic,assign) uint8_t deep_sleep_count;             //深睡次数
@property (nonatomic,assign) uint8_t wake_count;                   //醒来次数
@property (nonatomic,assign)  uint16_t ligth_sleep_minute;         //浅睡持续时长
@property (nonatomic,assign) uint16_t deep_sleep_minute;           //深睡持续时长
@property (nonatomic,copy) NSString *sleep_data_id;
- (id)initWith:(struct protocol_health_resolve_sleep_data_s)sleep;
- (void)saveWith:(NSString *)dateStr;

@end
