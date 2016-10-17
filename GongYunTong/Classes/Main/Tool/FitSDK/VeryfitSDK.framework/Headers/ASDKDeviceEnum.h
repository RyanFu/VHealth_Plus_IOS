//
//  AjSDKDeviceEnum.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "ASDKApi.h"

typedef enum {                                   // 详细的看接口参数。
    
    ASDKAcceptModelTypeUnKnown = 0,               // 无状态 0
    ASDKAcceptModelTypeBindingSuccess,            // 绑定成功
    ASDKAcceptModelTypeBindingTimeout,            // 绑定超时
    ASDKAcceptModelTypeBindingError,              // 绑定错误
    ASDKAcceptModelTypeUnBindingSuccess,          // 解绑成功
    ASDKAcceptModelTypeUnBindingFail,             // 解绑失败
    
    ASDKAcceptModelTypeDevideInfo,                // 设备信息
    ASDKAcceptModelTypeSetDateInfo,               // 时间信息
    ASDKAcceptModelTypeFunction,                  // 获取设备支持功能
    ASDKAcceptModelTypeUnitSuccess,               // 单位设置(包含时间)
    ASDKAcceptModelTypeUnitFail,                  // 单位设置10
    ASDKAcceptModelTypeSetUserInfo,               // 用户信息
    ASDKAcceptModelTypeSetUserInfoFail,           // 用户信息设置失败
    ASDKAcceptModelTypeSetAlarmClock,             // 设置闹钟
    ASDKAcceptModelTypeSetRemind,                 // 设置久坐提醒
    ASDKAcceptModelTypeSetRemindFail,             // 设置久坐提醒失败
    
    ASDKAcceptModelTypeSetSportTarget,            // 设置运动目标
    ASDKAcceptModelTypeSetSportTargetFail,
    ASDKAcceptModelTypeSetSleepTarget,            // 设置睡眠目标
    
    ASDKAcceptModelTypeDataRequestSuccess,        // 数据请求成功
    ASDKAcceptModelTypeDataTodaySport,            // 今天运动数据20
    ASDKAcceptModelTypeDataTodaySleep,            // 今天睡眠数据
    ASDKAcceptModelTypeDataTodayHeartRate,          // 今天心率数据.
    ASDKAcceptModelTypeDataHistorySport,          // 历史运动数据
    ASDKAcceptModelTypeDataHistorySleep,          // 历史睡眠数据.
    ASDKAcceptModelTypeDataHistoryHeartRate,          // 历史心率数据
    
    
    
    ASDKAcceptModelTypeDataRequestEnd,               // 数据请求结束
    ASDKAcceptModelTypeDataTodaySportEnd,            // 今天运动数据请求结束
    ASDKAcceptModelTypeDataTodaySleepEnd,            // 今天睡眠数据请求结束
    ASDKAcceptModelTypeDataTodayHeartRateEnd,            // 今天心率数据请求结束
    ASDKAcceptModelTypeDataHistorySportEnd,          // 历史运动数据请求结束 30
    ASDKAcceptModelTypeDataHistorySleepEnd,          // 历史睡眠数据请求结束.
    ASDKAcceptModelTypeDataHistoryHeartRateEnd,          // 历史心率数据请求结束.
    
    ASDKAcceptModelTypeRestoreData,                  // 恢复数据
    
    ASDKAcceptModelTypeSetLostModel,              // 丢失报警方式
    ASDKAcceptModelTypeSetAlertModel,             // 寻找报警方式
    ASDKAcceptModelTypeFindDevice,                // 寻找设备
    ASDKAcceptModelTypeLostEvent,                 // 防丢事件
    ASDKAcceptModelTypeKeyEvent,                  // 按键事件
    ASDKAcceptModelTypeOTASuccess,                // 进入ota成功
    ASDKAcceptModelTypeNoMuchElec,                // 没有足够的电量40
    ASDKAcceptModelTypeNoSupport,                 // 不支持
    ASDKAcceptModelTypeSuccess,                   // 通讯成功
    ASDKAcceptModelTypeError,                     // 通讯错误
    
    /*手环控制*/
    ASDKAcceptModelPhotoControl,
    ASDKAcceptModelPhotoControlFail,
    /*事件控制类型*/
    ASDKAcceptModelPhotoControlType,
    /*防丢模式*/
    ASDKAcceptModelLostMode,
    /*防丢模式失败*/
    ASDKAcceptModelLostModeFail,
    // 日志输出报告未完成
    ASDKAcceptModelReport,
    // 日志输出报告完成
    ASDKAcceptModelReportFinish,   //50
    // 重启
    ASDKAcceptModelReLoad,
    ASDKAcceptModelReLoadFail,
    
    //接听
    ASDKAcceptModelReceive,
    
    ASDKAcceptModelHangUp,
    
    //心率区间设置成功
    ASDKAcceptSetRateValueSuccess,
    ASDKAcceptSetRateValueFailu,
    //获取实时数据
    ASDKAcceptRealTimeData,
    
    ASDKacceptFindiPhone,
    ///通知中心开启成功
    ASDKAcceptCallReceiveOpenSuccess,
    ///通知中心开启失败
    ASDKAcceptCallReceiveOpenFail,
    ///通知中心开启未知超时
    ASDKAcceptCallReceiveOpenTimeout,  //60
    ///通知中心关闭成功
    ASDKAcceptCallReceiveCloseSuccess,
    ///通知中心关闭失败
    ASDKAcceptCallReceiveCloseFail,
    //通知中心关闭未知超时
    ASDKAcceptCallReceiveCloseTimeout,
    ///通知中心查询成功
    ASDKAcceptCallReceiveSearchSuccess,
    ///通知中心查询失败
    ASDKAcceptCallReceiveSearchFail,
    
    ///通知中心总开关开启
    ASDKAcceptCallReceiveOpen,
    ///通知中心总开关关闭
    ASDKAcceptCallReceiveClose,
    ///通知中心总查询失败
    ASDKAcceptCallReceiveFail,
    ///通知中心子开关设置成功
    ASDKAcceptCallChildSwitchSuccess,
    ///通知中心子开关设置失败
    ASDKAcceptCallChildSwitchFail, //70
    ///通知中心子开关设置超时
    ASDKAcceptCallChildSwitchTimeOut,
    
    ///请求开启ancs
    ASDKAcceptOpenAncsSuccess,
    //打开寻找手机成功
    ASDKAcceptOpenCloseFindIphoneSuccess,
    //打开寻找手机失败
    ASDKAcceptOpenCloseFindIphoneFail,
    //清除日志
    ASDKAcceptCleanLogSuccess,
    //打开函数日志
    ASDKAcceptOpenLogSuccess,
    //获取设备的mac
    ASDKAcceptGetServiceMacSuccess,  //77
    
    ASDKAcceptOneKeyRestoreSuccess,
    ASDKAcceptOneKeyRestoreFail,
    //打开关闭抬腕识别成功
    ASDKAcceptOpenCloseHandsupSuccess,
    //打开关闭抬腕识别成功
    ASDKAcceptOpenCloseHandsupFail,
    
    
} ASDKAcceptModelType;















