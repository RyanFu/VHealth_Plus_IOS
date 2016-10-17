//
//  ProtocolLiveDataModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/23.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"
#import "protocol.h"
/*
 uint32_t step;
 uint32_t calories;
 uint32_t distances;
 uint32_t active_time;
 uint8_t heart_rate;
 */

@interface ProtocolLiveDataModel : JKDBModel
@property (nonatomic,assign) uint32_t step;
@property (nonatomic,assign) uint32_t calories;
@property (nonatomic,assign) uint32_t distances;
@property (nonatomic,assign) uint32_t active_time;
@property (nonatomic,assign) uint8_t heart_rate;

@property (nonatomic,copy) NSString *smart_device_id;

- (id)initWith:(struct protocol_start_live_data )liveData;


@end
