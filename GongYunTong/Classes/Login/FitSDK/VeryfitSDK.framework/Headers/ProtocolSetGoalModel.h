//
//  ProtocolSetGoalModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/22.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//
/*
 uint8_t type; //00步数,01 卡路里,02 距离
 uint32_t data;  //数值
 uint8_t sleep_hour;
 uint8_t sleep_minute;
 */
#import "JKDBModel.h"
//目前只支持设置运动目标
typedef enum {
     GoalStep =0,
     GoalCalorie,
     GoalDistance
   
}GoalType;

@interface ProtocolSetGoalModel : NSObject
@property (nonatomic,assign) GoalType goalType;
@property (nonatomic,assign) NSInteger goal_sleep_data_hour;
@property (nonatomic,assign) NSInteger goal_sleep_data_minute;
@property (nonatomic,assign) NSInteger goal_sport_data;

@end
