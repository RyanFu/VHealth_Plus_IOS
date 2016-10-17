//
//  ASDKFounctionOrder.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDKDeviceEnum.h"
#import "ProtocolHandGestureModel.h"
#import "IntelligentRemindModel.h"
#import "ProtocolMusicModel.h"
#import "AlarmModel.h"
#import "ProtocolSetGoalModel.h"
#import "ProtocolDoNotDisturbModel.h"
#import "ProtocolHeartRateIntervalModel.h"
#import "ProtocolHandleTypeModel.h"

typedef enum {
    AlarmTypeAdd = 0,
    AlarmTypeDelete,
    AlarmTypeUpdate,
}AlarmFunctionType;


#pragma mark 传回数据block
/*  传回数据block
 *
 *  object 传回数据模型或字符
 *  isSuccess 是否调用成功
 */
typedef void(^BLTAcceptModelUpdateValue)(id object, int errorCode);
@interface ASDKFounctionOrder : NSObject

@property (nonatomic,copy) BLTAcceptModelUpdateValue bleUpdateBlock;


#pragma mark 设置时间
/*  设置时间
 *
 */
- (void)ASDKSendSetDeviceTimeWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 设置用户信息
/*  设置用户信息
 *
 *  info 用户信息(ProtocolUserInfoModel)
 *  @param block 传回数据
 */
- (void)ASDKSendSetUserInfo:(id)info
            WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取个人信息模型
/*   获取人信息模型（数据库）
 *
 *  @param id 为ProtocolUserInfoModel实例
 */
- (id)ASDKGetUserInfoModel;

#pragma mark 设置闹钟指令
/*   设置闹钟指令
 *
 *  @param info 闹钟模型
 *  @param type 操作类型（AlarmFunctionType）
 *  无论是更改还是删除还是更改 直接传数据库里获得的数据模型
 *  用ASDKSendGetDeviceAlarmClockWithUpdateBlock获取所有闹钟
 *  block 返回值，object为空，errcode如果为SUCCESS则为成功，如果为ALARM_COUNT_OUTDO 则为超过闹钟最大数量
 */
- (void)ASDKSendSetDeviceAlarmClock:(id )info
                           WithType:(AlarmFunctionType)type
                    WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取所有闹钟
/*   获取所有闹钟
 *
 *  @param id 传回数据 为AlarmModel 数组
 *  无论是更改还是删除还是更改 直接传数据库里获得的数据模型
 */
- (id)ASDKSendGetDeviceAlarmClock;

#pragma mark 设置久坐提醒
/*   设置久坐提醒
 *
 *  @param info 久坐模型（ProtocolSetLongSitModel）
 *  @param block 传回数据  object为nil errorCode为设置状态
 */
- (void)ASDKSendSetLongSitClock:(id )info
                WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取久坐提醒模型（数据库）
/*   获取久坐提醒模型（数据库）
 *
 *  @param id 传回数据 为ProtocolSetLongSitModel实例
 */
- (id)ASDKSendGetLongSitModel;



#pragma mark 单位设置
/*  设置
 *
 *  @param info 数据模型 ProtocolUnitModel
 *  @param block 传回数据 object为空，errorCode 为错误码
 */
- (void)ASDKSendSetUnit:(id)info
        withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取单位设置模型
/*  获取单位设置模型
 *
 *  @param id 传回数据 为ProtocolUnitModel
 */
- (id)ASDKGetUnitModel;

#pragma mark 设置运动目标
/*  设置运动目标
 *
 *  @param info 数据模型(ProtocolSetGoalModel)
 *  @param block 传回数据 object为nil errorCode为状态码
 */
- (void)ASDKSendSetSportTargetWithUpdate:(id)info
                         WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取设置目标模型
/*  获取设置目标模型
 *
 *  @param id 传回数据 为ProtocolSetGoalModel
 */
- (id)ASDKGetSetGoalModel;



#pragma mark 设置防丢模式
/*  设置防丢模式
 *
 *  @param info ProtocolLostFindModel
 *  @param block 传回数据 object为空 errorCode为状态码
 */
- (void)ASDKSendLostWithUpdateBlockState:(id)info WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取防丢模型
/*  获取防丢模型
 *
 *  @param block 传回数据 为ProtocolLostFindModel
 */
- (id)ASDKGetLostFindModel;

#pragma mark 设置来电提醒
/*  设置来电提醒
 *
 *  @param isOpen 是否开启来电提醒
 *  @param delay  来电提醒延时
 *  @param block object为nil，errorCode为错误码
 */
- (void)ASDKSendSetCallRemind:(BOOL)isOpen AndDelay:(int)delay WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 设置智能提醒开关
/*  设置智能提醒
 *
 *  @param remindModel IntelligentRemindModel
 *  @param block 传回数据 object为空，errorCode为错误码
 */
- (void)ASDKSendSetIntelligentRemind:(id)remindModel WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取智能提醒模型
/*  获取智能提醒模型
 *
 *  @param block 传回数据 为IntelligentRemindModel
 */
- (id)ASDKGetIntelligentRemindModel;

#pragma mark 打开关闭抬腕识别(抬手亮屏)
/*  打开关闭抬腕识别(抬手亮屏)
 *
 *  @param type 1 打开 0 关闭
 *  @param seconds 亮屏时间(2-7s)
 *  @param block 传回数据 object为空，errorCode为错误码
 */
- (void)ASDKSetHandsup:(BOOL)type ShowSecond:(NSInteger )seconds WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取抬腕识别模型
/*  获取抬腕识别模型
 *
 *  @param block 传回数据 为ProtocolHandGestureModel
 */
- (id)ASDKGetHandGestureModel;

#pragma mark 设置寻找手机
/*  设置寻找手机
 *
 *  @param isOpen 是否打开
 *  @param block 传回数据 object为nil，errorCode为错误码
 */
- (void)ASDKSendSetFindPhoneType:(BOOL)isOpen  withUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取寻找手机模型
/*  获取寻找手机模型
 *
 *  @param block 传回数据 ProtocolFindPhoneModel
 */

- (id)ASDKDetFindPhoneModel;

#pragma mark 打开音乐开关
/*  打开音乐开关
 *
 *  @param isOn 是否打开音乐开关
 *  @param block 传回打开状态
 */
- (void)ASDKSendOpenMusicSwitch:(BOOL )isOn WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取音乐开关模型
/*  获取音乐开关模型
 *
 *  返回音乐开关模型 ProtocolMusicModel
 */
- (ProtocolMusicModel *)ASDKGetProtocolMusicModel;

#pragma mark 获取总开关状态
/*  获取总开关状态
 *
 *  YES 打开 NO 关闭
 */
- (BOOL)ASDKSendGetCenterSwitchState;

#pragma mark 设置勿扰模式
/*  设置勿扰模式
 *
 *  @param donotdb 勿扰模式模型
 *  @param block
 */
- (void)ASDKSendSetDoNotDisturb:(ProtocolDoNotDisturbModel *)donotdb  WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取勿扰模式模型
/*  获取勿扰模式模型
 *
 */
- (ProtocolDoNotDisturbModel *)ASDKGetDisturbModel;

#pragma mark 设置心率区间
/*  设置心率区间
 *
 *  @param hrinterval ProtocolHeartRateIntervalModel 实例
 *  @param block 返回状态
 */
- (void)ASDKSendSetHeartRate:(ProtocolHeartRateIntervalModel *)hrinterval WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取心率区间模型
/*  获取心率区间模型
 *
 */
- (ProtocolHeartRateIntervalModel *)ASDKSendGetHeartRateIntervalModel;

#pragma mark 设置左右手穿戴
/*  设置左右手穿戴
 *  
 *  @param handletype ProtocolHandleTypeModel 实例
 *  @param block 传回数据
 */
- (void)ASDKSendSetHandelTyle:(id)handletype WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取左右手穿戴模型
/*  获取左右手穿戴模型
 *
 *  id 返回数据 为ProtocolHandleTypeModel 实例
 */
- (id)ASDKGetHandelTypeModel;

#pragma mark 设置心率模式
/*  设置心率模式
 *
 *  @param isAutomic 是否自动
 */
- (void)ASDKSendSetHeartRateModel:(BOOL)isAutomic WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

#pragma mark 获取心率模式模型
/*  获取心率模式模型
 *
 *  @param id为 ProtocolHRModeModel 实例
 */
- (id)ASDKGetHrartRateModeModel;

#pragma mark 清除当天数据
/*  清除当天数据
 *
 */
- (BOOL)deleteCurrentDateData;

#pragma mark 更新user_id
/*  更新user_id
 *
 *  @param user_id user_id 用户id
 */
+ (BOOL)upDateUserIdWith:(NSString *)user_id;

@end
