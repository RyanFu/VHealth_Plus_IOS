//
//  VHSActionData.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSActionData : NSObject

/// 单次计步ID，取时间戳,精确到毫秒
@property (nonatomic, strong) NSString * actionId;

/// 用户ID
@property (nonatomic, strong) NSString * memberId;

/// 取0
@property (nonatomic, strong) NSString * actionMode;

/// 记步类型 1为手环记步 2为手机记步
@property (nonatomic, strong) NSString * actionType;

/// 本次运动的距离，单位KM
@property (nonatomic, strong) NSString * distance;

/// 本次运动的时长，单位S
@property (nonatomic, strong) NSString * seconds;

/// 卡路里
@property (nonatomic, strong) NSString * calorie;

/// 步数
@property (nonatomic, strong) NSString * step;

/// 当前记录数据时间 单位 天
@property (nonatomic, copy) NSString * recordTime;

/// 本次运动开始时间
@property (nonatomic, strong) NSString * startTime;

/// 本次运动结束时间
@property (nonatomic, strong) NSString * endTime;

/// 本次运动积分
@property (nonatomic, strong) NSString * score;

/// 是否上传标志，1为已上传
@property (nonatomic, assign) NSInteger upload;

/// mac 地址 用于记录手环的地址 －－ 从HealthKit中获取的纪录 Mac地址为000000(随意定义)
@property (nonatomic, strong) NSString * macAddress;
/// 爬楼
@property (nonatomic, strong) NSString * floorAsc;
/// 下楼
@property (nonatomic, strong) NSString * floorDes;
/// 定时任务的类型
@property (nonatomic, strong) NSString * taskType;

@end
