//
//  VHSStepAlgorithm.h
//  GongYunTong
//
//  Created by ios-bert on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "VHSActionData.h"
#import "VHSBraceletCoodinator.h"

@interface VHSStepAlgorithm : NSObject


@property (nonatomic, strong) CMPedometer *pedometer;

@property (retain, nonatomic) VHSActionData *stepsData;

+ (VHSStepAlgorithm *)shareAlgorithm;

- (void)setupStepRecorder;

/// 开启监测手环的定时器
- (void)fireTimer;
/// 失效监听器
- (void)invalidateTimer;

#pragma mark - 手环SDK

/// 获取手环中指定一天的数据 - @param : date yyyymmdd
- (void)sportDayWithDate:(NSString *)date sportBlock:(void (^)(ProtocolSportDataModel *sportData))sportDataBlock;
/// 获取手环实时的信息
- (void)realtimeBraceletDataBlock:(void (^)(ProtocolLiveDataModel *liveData))realtimeBlock;

#pragma mark - 同步手环数据到手机
/// 同步手环到手机本地数据库
- (void)asynDataFromBraceletToMobileDB:(void (^)())syncSuccess;
/// 同步手环数据到手环厂商数据库表中
- (void)asynDataMySelfTable:(void (^)(int errorCode))syncBlock;

#pragma mark - 手环数据相关

/// 获取用户一天的所有步数 date : yyyyMMdd
- (NSInteger)selecteSumStepsWithMemberId:(NSString *)memberId date:(NSString *)date;

/// 上传所有的未上传的数据
- (void)uploadAllUnuploadActionData:(void (^)(NSDictionary *result))syncBlock;

/// 插入或者更新手环数据
- (void)insertOrUpdateBleAction:(VHSActionData *)action;

/// 更新运动步数
- (void)updateSportStep:(VHSActionData *)action;

@end
