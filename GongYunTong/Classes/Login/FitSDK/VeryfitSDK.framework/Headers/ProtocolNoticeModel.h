//
//  ProtocolNoticeModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/23.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//  智能提醒model

#import "JKDBModel.h"

@interface ProtocolNoticeModel : JKDBModel

@property (nonatomic,assign) uint8_t notify_switch;
@property (nonatomic,assign) uint8_t notify_itme1;
@property (nonatomic,assign) uint8_t notify_itme2;
@property (nonatomic,assign) uint8_t call_switch;
@property (nonatomic,assign) uint8_t call_delay;

@property (nonatomic,copy) NSString *smart_device_id;

@end
