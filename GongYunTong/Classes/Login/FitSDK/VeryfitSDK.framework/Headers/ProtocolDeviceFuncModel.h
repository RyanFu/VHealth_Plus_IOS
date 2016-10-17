//
//  DeviceFuncModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/16.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
#import "protocol_func_table.h"
/*
 功能列表
 */

@interface ProtocolMain:JKDBModel
//主功能

//有无运动功能
@property (nonatomic,assign) bool stepCalculation;
//有无睡眠监测功能
@property (nonatomic,assign) bool sleepMonitor;
//有无单次运动功能
@property (nonatomic,assign) bool singleSport;
//有无实时数据功能
@property (nonatomic,assign) bool realtimeData;
//有无设备更新功能
@property (nonatomic,assign) bool deviceUpdate;
//有无心率功能
@property (nonatomic,assign) bool heartRate;
//有无通知中心
@property (nonatomic,assign)  bool Ancs;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_main )main;

@end
@interface ProtocolTableControl:JKDBModel
//控制功能

//有无拍照功能
@property (nonatomic,assign) bool takePhoto;
//有无音乐功能
@property (nonatomic,assign) bool music;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_control )control;
@end



@interface ProtocolAlarmType : JKDBModel
 // 闹钟提醒支持类型

//有无起床提醒功能
@property (nonatomic,assign) bool wakeUp;
//有无睡觉提醒功能
@property (nonatomic,assign) bool sleep;
//有无锻炼提醒功能
@property (nonatomic,assign) bool sport;
//有无吃药提醒功能
@property (nonatomic,assign) bool medicine;
//有无约会提醒功能
@property (nonatomic,assign) bool dating;
//有无聚会提醒功能
@property (nonatomic,assign) bool party;
//有无会议提醒功能
@property (nonatomic,assign) bool metting;
//有无自定义闹钟功能
@property (nonatomic,assign) bool custom;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_alarm_type )alarmType;

@end
@interface ProtocolTableCall : JKDBModel
// 来电提醒功能

//有无来电提醒功能
@property (nonatomic,assign) bool calling;
//有无显示来电联系人功能
@property (nonatomic,assign) bool callingContact;
//有无显示来电号码功能
@property (nonatomic,assign) bool callingNum;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_call)call;
@end

@interface ProtocolNotify : JKDBModel
// 信息提醒功能

//有无短信提醒功能
@property (nonatomic,assign) bool message;
//有无邮件提醒功能
@property (nonatomic,assign) bool email;
//有无QQ提醒功能
@property (nonatomic,assign) bool qq;
//有无微信提醒功能
@property (nonatomic,assign) bool weixin;
//有无新浪微博提醒功能
@property (nonatomic,assign) bool sinaWeibo;
//有无facebook提醒功能
@property (nonatomic,assign) bool facebook;
//有无twitter提醒功能
@property (nonatomic,assign) bool twitter;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_notify )notifyNew;

@end

//信息提醒功能1

@interface ProtocolNotify1 : JKDBModel
//有无whatsapp提醒功能
@property (nonatomic,assign) bool whatsapp;
//有无messengre提醒功能
@property (nonatomic,assign) bool messengre;
//有无instagram提醒功能
@property (nonatomic,assign) bool instagram;
//有无linked_in提醒功能
@property (nonatomic,assign) bool linked_in;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_notify2)notify;
@end

@interface ProtocolOther : JKDBModel
// 其他功能


// 其他功能
//有无久坐提醒功能
@property (nonatomic,assign) bool sedentariness;
//有无防丢提醒功能
@property (nonatomic,assign) bool antilost;
//有无一键呼叫功能
@property (nonatomic,assign) bool onetouchCalling;
//有无寻找手机功能
@property (nonatomic,assign) bool findPhone;
//有无寻找手环功能
@property (nonatomic,assign) bool findDevice;

//有无默认模式功能
@property (nonatomic,assign) bool configDefault;
//有无手势功能
@property (nonatomic,assign) bool upHandGesture;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_other )other;

@end

@interface ProtocolTableSms : JKDBModel
// 信息提醒配置
//有无提示信息联系人功能
@property (nonatomic,assign) bool tipInfoContact;
//有无提示信息号码
@property (nonatomic,assign) bool tipInfoNum;
//有无提醒信息内容
@property (nonatomic,assign) bool tipInfoContent;

@property (nonatomic,copy) NSString *smart_device_id;
- (id)initWith:(struct protocol_func_table_sms )sms;
@end

@interface ProtocolOtherFun2 : JKDBModel
/*静态心率*/
@property(nonatomic,assign) bool staticHR;
/*防打扰*/
@property(nonatomic,assign) bool doNotDisturb;

/*显示模式*/
@property(nonatomic,assign) bool displayMode;

/*心率监测*/
@property(nonatomic,assign) bool heartRateMonitor;


@property (nonatomic,copy) NSString *smart_device_id;

- (id)initWith:(struct protocol_func_table_ohter2 )other;
@end

@interface ProtocolDeviceFuncModel : JKDBModel
@property (nonatomic,strong) ProtocolMain *mainFunc;
@property (nonatomic,assign) uint8_t alarm_count;
@property (nonatomic,strong) ProtocolTableControl *control;
@property (nonatomic,strong) ProtocolTableCall *call;
@property (nonatomic,strong) ProtocolNotify  *notifyNew;
@property (nonatomic,strong) ProtocolNotify1 *notifyNew1;
@property (nonatomic,strong) ProtocolOther *otherFunc;
@property (nonatomic,strong) ProtocolTableSms *smsFunc;
@property (nonatomic,strong) ProtocolAlarmType *alarmType;
@property (nonatomic,strong) ProtocolOtherFun2 *other2;

//是否支持智能闹钟功能
@property (nonatomic,assign) bool smart_alarm_fun;
//是否支持智能提醒功能
@property (nonatomic,assign) bool smart_remind_fun;

@property (nonatomic,copy) NSString *smart_device_id;


- (id)initWith:( struct protocol_func_table )table;
@end
