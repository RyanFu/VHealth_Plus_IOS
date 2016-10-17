//
//  DataModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/3.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef enum {                                   // 详细的看接口参数。
    
    BLTAcceptModelTypeUnKnown = 0,               // 无状态 0
    BLTAcceptModelTypeBindingSuccess,            // 绑定成功
    BLTAcceptModelTypeBindingTimeout,            // 绑定超时
    BLTAcceptModelTypeBindingError,              // 绑定错误
    BLTAcceptModelTypeUnBindingSuccess,          // 解绑成功
    BLTAcceptModelTypeUnBindingFail,             // 解绑失败
    
    BLTAcceptModelTypeDevideInfo,                // 设备信息
    BLTAcceptModelTypeSetDateInfo,               // 时间信息
    BLTAcceptModelTypeFunction,                  // 获取设备支持功能
    BLTAcceptModelTypeUnitSuccess,               // 单位设置(包含时间)
    BLTAcceptModelTypeUnitFail,                  // 单位设置10
    BLTAcceptModelTypeSetUserInfo,               // 用户信息
    BLTAcceptModelTypeSetUserInfoFail,           // 用户信息设置失败
    BLTAcceptModelTypeSetAlarmClock,             // 设置闹钟
    BLTAcceptModelTypeSetRemind,                 // 设置久坐提醒
    BLTAcceptModelTypeSetRemindFail,             // 设置久坐提醒失败
    
    BLTAcceptModelTypeSetSportTarget,            // 设置运动目标
    BLTAcceptModelTypeSetSportTargetFail,
    BLTAcceptModelTypeSetSleepTarget,            // 设置睡眠目标
    
    BLTAcceptModelTypeDataRequestSuccess,        // 数据请求成功
    BLTAcceptModelTypeDataTodaySport,            // 今天运动数据20
    BLTAcceptModelTypeDataTodaySleep,            // 今天睡眠数据
    BLTAcceptModelTypeDataTodayHeartRate,          // 今天心率数据.
    BLTAcceptModelTypeDataHistorySport,          // 历史运动数据
    BLTAcceptModelTypeDataHistorySleep,          // 历史睡眠数据.
    BLTAcceptModelTypeDataHistoryHeartRate,          // 历史心率数据
    
    
    
    BLTAcceptModelTypeDataRequestEnd,               // 数据请求结束
    BLTAcceptModelTypeDataTodaySportEnd,            // 今天运动数据请求结束
    BLTAcceptModelTypeDataTodaySleepEnd,            // 今天睡眠数据请求结束
    BLTAcceptModelTypeDataTodayHeartRateEnd,            // 今天心率数据请求结束
    BLTAcceptModelTypeDataHistorySportEnd,          // 历史运动数据请求结束 30
    BLTAcceptModelTypeDataHistorySleepEnd,          // 历史睡眠数据请求结束.
    BLTAcceptModelTypeDataHistoryHeartRateEnd,          // 历史心率数据请求结束.
    
    BLTAcceptModelTypeRestoreData,                  // 恢复数据
    
    BLTAcceptModelTypeSetLostModel,              // 丢失报警方式
    BLTAcceptModelTypeSetAlertModel,             // 寻找报警方式
    BLTAcceptModelTypeFindDevice,                // 寻找设备
    BLTAcceptModelTypeLostEvent,                 // 防丢事件
    BLTAcceptModelTypeKeyEvent,                  // 按键事件
    BLTAcceptModelTypeOTASuccess,                // 进入ota成功
    BLTAcceptModelTypeNoMuchElec,                // 没有足够的电量40
    BLTAcceptModelTypeNoSupport,                 // 不支持
    BLTAcceptModelTypeSuccess,                   // 通讯成功
    BLTAcceptModelTypeError,                     // 通讯错误
    
    /*手环控制*/
    BLTAcceptModelPhotoControl,
    BLTAcceptModelPhotoControlFail,
    /*事件控制类型*/
    BLTAcceptModelPhotoControlType,
    /*防丢模式*/
    BLTAcceptModelLostMode,
    /*防丢模式失败*/
    BLTAcceptModelLostModeFail,
    // 日志输出报告未完成
    BLTAcceptModelReport,
    // 日志输出报告完成
    BLTAcceptModelReportFinish,   //50
    // 重启
    BLTAcceptModelReLoad,
    
    //接听
    BLTAcceptModelReceive,
    
    BLTAcceptModelHangUp,
    
    //心率区间设置成功
    BLTAcceptSetRateValueSuccess,
    BLTAcceptSetRateValueFailu,
    //获取实时数据
    BLTAcceptRealTimeData,
    
    BLTacceptFindiPhone,
    ///通知中心开启成功
    BLTAcceptCallReceiveOpenSuccess,
    ///通知中心开启失败
    BLTAcceptCallReceiveOpenFail,
    ///通知中心开启未知超时
    BLTAcceptCallReceiveOpenTimeout,  //60
    ///通知中心关闭成功
    BLTAcceptCallReceiveCloseSuccess,
    ///通知中心关闭失败
    BLTAcceptCallReceiveCloseFail,
    //通知中心关闭未知超时
    BLTAcceptCallReceiveCloseTimeout,
    ///通知中心查询成功
    BLTAcceptCallReceiveSearchSuccess,
    ///通知中心查询失败
    BLTAcceptCallReceiveSearchFail,
    
    ///通知中心总开关开启
    BLTAcceptCallReceiveOpen,
    ///通知中心总开关关闭
    BLTAcceptCallReceiveClose,
    ///通知中心总查询失败
    BLTAcceptCallReceiveFail,
    ///通知中心子开关设置成功
    BLTAcceptCallChildSwitchSuccess,
    ///通知中心子开关设置失败
    BLTAcceptCallChildSwitchFail, //70
    ///通知中心子开关设置超时
    BLTAcceptCallChildSwitchTimeOut,
    
    ///请求开启ancs
    BLTAcceptOpenAncsSuccess,
    //打开寻找手机成功
    BLTAcceptOpenCloseFindIphoneSuccess,
    //打开寻找手机失败
    BLTAcceptOpenCloseFindIphoneFail,
    //清除日志
    BLTAcceptCleanLogSuccess,
    //打开函数日志
    BLTAcceptOpenLogSuccess,
    //获取设备的mac
    BLTAcceptGetServiceMacSuccess,  //77
    
    BLTAcceptOneKeyRestoreSuccess,
    BLTAcceptOneKeyRestoreFail,
    //打开关闭抬腕识别成功
    BLTAcceptOpenCloseHandsupSuccess,
    //打开关闭抬腕识别成功
    BLTAcceptOpenCloseHandsupFail,
    
    
} BLTAcceptModelType;
@interface ASDKDataModel : NSObject
@property (nonatomic, assign) BLTAcceptModelType type;
- (NSString *)acceptData:(NSData *)data withPeripheral:(CBPeripheral *)peripheral;
+ (void)writeDataToFile:(NSData *)data className:(NSString *)className fileType:(NSString *)name;
@end
