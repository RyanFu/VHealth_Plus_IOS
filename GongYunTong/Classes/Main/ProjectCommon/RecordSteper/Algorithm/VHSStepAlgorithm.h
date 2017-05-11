//
//  VHSStepAlgorithm.h
//  GongYunTong
//
//  Created by ios-bert on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "VHSActionData.h"

@interface VHSStepAlgorithm : NSObject

@property (nonatomic, assign) CBManagerState CBState;

@property (nonatomic, strong) CMPedometer *pedometer;

@property (assign, nonatomic) NSInteger stepIncreaseCount;//步数增量
@property (retain, nonatomic) VHSActionData *stepsData;

+ (VHSStepAlgorithm *)shareAlgorithm;

/// 开始手机计步
- (void)startMobileStepRecord;
/// 开始手环计步
- (void)startBleStepRecord;
/// 关闭手机计步
- (void)stopPedometerCount;

/// 开启监测手环的定时器
- (void)fireTimer;
/// 失效监听器
- (void)invalidateTimer;

#pragma mark - 同步手环数据到手机
/// 同步手环到手机本地数据库
- (void)asynDataFromBraceletToMobileDB:(void (^)())syncSuccess;

#pragma mark - 手环数据相关

/// 获取用户一天的所有步数 date : yyyyMMdd
- (NSInteger)getsDayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime;

/// 上传所有的未上传的数据
- (void)uploadAllUnuploadActionData:(void (^)(NSDictionary *result))syncBlock;

/// 更新运动步数
- (void)updateSportStep:(VHSActionData *)action;

/// 插入一条运动数据
- (BOOL)insertAction:(VHSActionData *)action;

/// 更新一条数据
- (void)updateAction:(VHSActionData *)action;

/// 删除运动数据表中所有的数据
- (void)deleteAllAction;

@end
