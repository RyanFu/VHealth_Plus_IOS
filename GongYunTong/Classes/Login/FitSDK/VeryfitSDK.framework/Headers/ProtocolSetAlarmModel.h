//
//  ProtocolSetAlarmModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/21.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@interface ProtocolSetAlarmModel : JKDBModel

//是否同步
@property (nonatomic,assign) BOOL is_synchronize;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *hour;
@property (nonatomic,copy) NSString *minute;
@property (nonatomic,copy) NSString *repeat;
@property (nonatomic,copy) NSString *tsnooze_duration;
@property (nonatomic,copy) NSString *alarm_id;

@property (nonatomic,copy) NSString *smart_device_id;

@end
