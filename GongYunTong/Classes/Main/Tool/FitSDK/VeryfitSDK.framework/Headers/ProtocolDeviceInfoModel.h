//
//  DeviceInfoModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/16.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "protocol.h"
#import "JKDBModel.h"

@interface ProtocolDeviceInfoModel : JKDBModel
//设备id
@property(nonatomic,copy) NSString * device_id;
//版本号
@property(nonatomic,copy) NSString * version;
//模式
@property (nonatomic,copy) NSString * model;
//电池状态
@property (nonatomic,copy) NSString * batt_status;
//电量等级
@property (nonatomic,copy) NSString * batt_level;
//绑定状态
@property (nonatomic,copy) NSString * pair_flag;
//是否重启
@property (nonatomic,copy) NSString * reboot_flag;
//设备Mac地址
@property (nonatomic,copy) NSString *mac_address;
//设备uuid
@property (nonatomic,copy) NSString *device_pk_id;
//设备类型
@property (nonatomic,copy) NSString *type;
- (id)initWith:(struct protocol_device_info *)info;
@end
