//
//  AjSDKGetHandringData.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASDKDeviceEnum.h"

#pragma mark 传回数据block
/*  传回数据block
 *
 *  object 传回数据模型或字符
 *  isSuccess 是否调用成功
 */
typedef void(^BLTAcceptModelUpdateValue)(id object, int errorCode);


@interface ASDKGetHandringData : NSObject
@property (nonatomic,copy) BLTAcceptModelUpdateValue bleUpdateBlock;

#pragma mark 获取设备信息
/*  获取设备信息
 *
 *  @param block 传回数据
 */
- (void)ASDKSendGetDeviceInfoWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取设备信息模型
/*  获取设备信息
 *
 *  @param block 传回数据 ProtocolDeviceInfoModel
 */
- (id)ASDKSendGetDeviceInfoModel;

#pragma mark 获取功能列表模型(数据库)
/*  获取功能列表模型(数据库)
 *
 *  @param block 传回数据 为DeviewFuncModel
 */
- (id)ASDKSendGetDeviceFunctionModel;

#pragma mark 同步当天数据
/*  发送同步当天的运动和睡眠详情请求
 *
 *  @param info 数据模型
 *  @param block 传回数据
 */
- (void)ASDKSendRequestSportDataForTodayWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 按日期和DevicePkId获取日运动数据
/*  按日期和DevicePkId获取日运动数据
 *
 *  @param dateStr 日期
 *  @param pkId 设备DevicePkId
 *  @param id 传回ProtocolSportDataModel
 */
- (id)ASDKSendGetSportData:(NSString *)dateStr AndDevicePkId:(NSString *)pkId;


#pragma mark 按日期和DevicePkId获取日睡眠数据
/*  按日期和DevicePkId获取日运动数据
 *
 *  @param dateStr 日期
 *  @param pkId 设备DevicePkId
 */
- (id)ASDKSendGetSleepData:(NSString *)dateStr AndDevicePkId:(NSString *)pkId;

#pragma mark 按日期和uuid获取日心率数据
/*  按日期和uuid获取日心率数据
 *
 *  @param dateStr 日期
 *  @param uuid 设备uuid
 */
- (id)ASDKSendGetHeartrateData:(NSString *)dateStr AndDevicePkId:(NSString *)pkId;

#pragma mark 同步闹钟数据
/*  发送同步当天的运动和睡眠详情请求
 *
 *  @param block 传回数据
 */
- (void)ASDKSendRequestAlarmDataWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 同步配置信息
/*  发送同步配置信息请求
 *
 *  @param block 传回数据 object为空 errorCode为错误码
 */
- (void)ASDKSendRequestConfigWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取实时设备数据
/*  获取实时设备数据
 *
 *  @param block 传回数据 object为ProtocolLiveDataModel errorCode为错误码
 */
- (void)ASDKSendDataToAcceptRealTimeDataWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

/*  获取实时设备数据
 *
 *  @param block 传回数据 object为ProtocolLiveDataModel errorCode为错误码
 */
#pragma mark 获取实时数据（数据库）
- (void)ASDKSendGetLiveDataModelWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取设备mac地址
/*  获取设备mac地址
 *
 *  @param info 数据模型
 *  @param block 传回数据
 */
- (void)ASDKGetServiceMacWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 根据日期计算周详情数据(运动数据和睡眠数据)
/*  计算周详情数据
 *
 *  @param block 传回数据
 */
- (id)ASDKCalculateWeekDataWithDate:(NSDate *)date;

#pragma mark 根据日期计算月详情数据
/*  计算月详情数据
 *
 *  @param block 传回数据
 */
- (id)ASDKCalculateMonthDataForWithDate:(NSDate *)date;


#pragma mark 根据日期计算年详情数据
/*  计算年详情数据
 *
 *  @param block 传回数据
 */
- (id)ASDKCalculateYearDataForWithDate:(NSDate *)date;

#pragma mark 根据日期时间段获取详情数据
/*  根据日期时间段获取详情数据
 *
 *  @param startDate 开始日期
 *  @param endDate 结束日期
 *  @param block 传回数据
 */
- (void)ASDKSendGetDateZoneStart:(NSDate *)startDate endDate:(NSDate *)endDate WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取全部运动和睡眠数据
/*  获取全部运动和睡眠数据
 *
 *  @param block 传回数据 object 为运动数据数组 @[SpoerArr,SleepArray] 结构
 */
- (void)ASDKGetAllHealthDataWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取全部心率数据
/*  获取全部获取全部心率数据
 *
 *  @param block 传回数据 object 为运动数据数组 HeartArray 结构
 */
- (void)ASDKGetAllHearthRateDataWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

@end
