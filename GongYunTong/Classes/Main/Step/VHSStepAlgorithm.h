//
//  VHSStepAlgorithm.h
//  GongYunTong
//
//  Created by ios-bert on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
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

- (void)start;

/// 开启监测手环的定时器
- (void)fireTimer;
/// 失效监听器
- (void)invalidateTimer;

/// 尝试重新连接手环
- (void)tryReconnectedBracelet;

#pragma mark - 手环SDK
/// 初始化手环
- (void)shareBLE;

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

/**
 *  插入或者更新一个数据
 *
 *  @param steps      增量步数
 *  @param recordTime 记录时间
 *  @param actionType 活动类型 1:手环 2:手机
 */
- (void)insertOrUpdateBleAction:(VHSActionData *)action;

/**
 *  更新运动步数
 *
 *  @param action 运动数据
 */
- (void)updateSportStep:(VHSActionData *)action;

@end
