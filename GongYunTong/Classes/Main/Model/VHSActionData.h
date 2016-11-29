//
//  VHSActionData.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSActionData : NSObject

///单次计步ID，取时间戳,精确到毫秒
@property (nonatomic, strong) NSString *actionId;
/// 用户ID
@property (nonatomic, strong) NSString *memberId;
///取0
@property (nonatomic) NSInteger actionMode;
/// 记步类型 1为手环记步 2为手机记步
@property (nonatomic, strong) NSString *actionType;
///本次运动的距离，单位KM
@property (nonatomic) CGFloat  distance;
/////本次运动的时长，单位S
@property (nonatomic) NSInteger seconds;
///卡路里
@property (nonatomic) NSInteger calorie;
////步数
@property (nonatomic) NSInteger step;
///本次运动开始时间
@property (nonatomic, strong) NSString *startTime;
/// 本次运动结束时间
@property (nonatomic) NSString *endTime;
/// 当前记录数据时间 单位 天
@property (nonatomic) NSString *recordTime;
///本次运动积分
@property (nonatomic) NSInteger score;
///是否上传标志，1为已上传
@property (nonatomic) NSInteger upload;
///速度 km/h
@property (nonatomic) CGFloat speed;
/// mac 地址 用于记录手环的地址 －－ 从HealthKit中获取的纪录 Mac地址为000000(随意定义)
@property (nonatomic) NSString *macAddress;

@property(nonatomic,strong) NSString *date;



@end
