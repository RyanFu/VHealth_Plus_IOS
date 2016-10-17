//
//  HeartRateModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/17.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
#import "protocol_health_resolve_heart_rate.h"
@interface HeartReteItem : JKDBModel

@property (nonatomic,assign) uint8_t offset;
@property (nonatomic,assign) uint8_t data;                  //最小阀值
@property (nonatomic,copy) NSString *date;                  //日期
@property (nonatomic,copy) NSString *heart_rate_id;

- (id)initWith:(struct ble_sync_heart_rate_item)item;
@end

@interface ProtocolHeartRateModel : JKDBModel

@property (nonatomic,copy)   NSString *itmes_count;

@property (nonatomic,strong) NSArray *HeartRateArray;
@property (nonatomic,copy) NSString *date;

/*
 heartratehead
 */
@property (nonatomic,assign) uint16_t minute_offset;
@property (nonatomic,assign) uint8_t silent_heart_rate;     //静息心率
/*
 heartratehead1
 */
@property (nonatomic,assign) uint8_t burn_fat_threshold;    //燃烧脂肪阀值
@property (nonatomic,assign) uint8_t aerobic_threshold;     //肌肉锻炼阀值
@property (nonatomic,assign) uint8_t limit_threshold;       //极限阀值
@property (nonatomic,assign) uint8_t burn_fat_mins;         //脂肪燃烧时长
@property (nonatomic,assign) uint16_t aerobic_mins;         //肌肉锻炼时长
@property (nonatomic,assign) uint16_t limit_mins;//极限运动时长

@property (nonatomic,copy) NSString *heart_rate_id;
@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_health_resolve_heart_rate_data_s)heart;
- (void)saveWith:(NSString *)dataStr;

@end
