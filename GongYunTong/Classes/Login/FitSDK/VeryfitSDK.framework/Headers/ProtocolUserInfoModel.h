//
//  ProtocolUserInfoModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/21.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "JKDBModel.h"
#import "ProtocolSetGoalModel.h"
@interface ProtocolUserInfoModel : JKDBModel
/*
 uint8_t heigth;     //升高
 uint16_t weight;    //体重
 uint8_t gender;
 uint16_t year;      //生日
 uint8_t monute;
 uint8_t day;
 */
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *weight;
@property (nonatomic,copy) NSString *gender;
//生日
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *day;
//目标
@property (nonatomic,assign) NSInteger goal_sleep_data_hour;
@property (nonatomic,assign) NSInteger goal_sleep_data_minute;
@property (nonatomic,assign) NSInteger goal_sport_data;
@property (nonatomic,assign) GoalType goal_type;
@property (nonatomic,copy) NSString *user_id;



@end
