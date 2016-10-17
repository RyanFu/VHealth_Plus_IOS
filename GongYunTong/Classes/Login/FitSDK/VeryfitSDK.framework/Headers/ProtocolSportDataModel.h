//
//  SportDataModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/17.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "protocol.h"
#import "protocol_health_resolve_sport.h"
#import "JKDBModel.h"

@interface SportItem : JKDBModel

@property (nonatomic,copy) NSString *sport_data_id;

@property (nonatomic,assign) uint16_t mode;
@property (nonatomic,assign) uint16_t sport_count;
@property (nonatomic,assign) uint16_t active_time;            //活跃时间
@property (nonatomic,assign) uint16_t calories;               //卡路里
@property (nonatomic,assign) uint16_t distance;               //距离
@property (nonatomic,copy)   NSString *date;


- (id)initWith:(struct ble_sync_sport_item)item;
@end


@interface ProtocolSportDataModel : JKDBModel
@property (nonatomic,copy)  NSString * items_count;
@property (nonatomic,copy)   NSString *date;
@property (nonatomic,strong) NSArray *sportItem;

@property (nonatomic,copy) NSString *smart_device_id;
@property (nonatomic,copy) NSString *sport_data_id;
/*
 SportHead1
*/
@property (nonatomic,assign) uint32_t total_step;              //总步数
@property (nonatomic,assign) uint32_t total_cal;               //总卡路里
@property (nonatomic,assign) uint32_t total_distances;         //总距离
@property (nonatomic,assign) uint32_t total_active_time;       //总活动时长

/*
  SportHead
 */
@property (nonatomic,assign) uint16_t minute_offset;           //开始偏移
@property (nonatomic,assign) uint8_t per_minute;               //产生数据间隔


- (id)initWith:(struct protocol_health_resolve_sport_data_s)sport;
- (void)saveWith:(NSString *)dataStr;
@end
