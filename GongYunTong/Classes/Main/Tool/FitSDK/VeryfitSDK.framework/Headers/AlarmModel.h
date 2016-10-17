//
//  AlarmModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/1.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    AlarmTypeGetUp = 10,      //起床
    AlarmTypeSleep,           //睡觉
    AlarmTypeExercise,        //锻炼
    AlarmTypeMedicine,        //吃 药
    AlarmTypeAppointment,     //约会
    AlarmTypeParty ,          //聚会
    AlarmTypeMetting ,        //会议
    AlarmTypeCustom ,         //自定义
   
    
}AlarmType;
@interface AlarmModel : NSObject
@property (nonatomic,copy) NSString *alarm_id;           //闹钟id 添加时无需手动设置
@property (nonatomic,assign) AlarmType type;
@property (nonatomic,assign) NSInteger hour;             //闹钟时 24小时制
@property (nonatomic,assign) NSInteger minute;           //闹钟分
@property (nonatomic,assign) NSInteger snooze_duration;  //贪睡时长
@property (nonatomic,assign) BOOL isOpen;                //是否开启
@property (nonatomic,strong) NSArray *selectArray;       //选中1星期中需要重复的星期
@property (nonatomic,assign) BOOL is_synchronize;        //是否已同步
@end
