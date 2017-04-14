//
//  VHSCommon.h
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "UserDetailModel.h"


///const 通知key
extern NSString *const DeviceDidScanBLEsUserInfoKey;     //扫描到手环通知里userinfo的key
extern NSString *const DeviceDidConnectedBLEsNotification;   //与手环连接成功通知
extern NSString *const DeviceDidConnectedBLEsUserInfoPeripheral;   //与手环连接成功通知里userinfo的key

@interface VHSCommon : NSObject

/// app的应用名称
+ (NSString *)appName;
///  app 版本
+ (NSString *)appVersion;
/// 系统版本
+ (NSString *)osVersion;
/// 系统名字
+ (NSString *)osName;
/// 版本和名字
+ (NSString *)osNameVersion;
/// 获取开发厂商ID
+ (NSString *)idfv;
/// 获取uuid - 通过钥匙串的方式存储，和获取
+ (NSString *)deviceToken;
/// 获取手机型号
+ (NSString *)phoneModel;
/// 跳转AppStore
+ (void)toAppStore;
/// 跳转到Safari
+ (void)toSafariWithUrl:(NSString *)urlAddress;
/// 获取vhstoken
+ (NSString *)vhstoken;
/// 获取本地经纬度
+ (NSString *)latitudeLongitude;
/// 移除本地用户信息 － 包括缓存
+ (void)removeLocationUserInfo;

/// UserDefault保存信息
+ (void)saveUserDefault:(id)value forKey:(NSString *)key;
/// 从UserDefault中获取信息
+ (id)getUserDefautForKey:(NSString *)key;
/// 从NSUserDefault中移除为key的数据
+ (void)removeUserDefaultForKey:(NSString *)key;

// 校验简单密码
+ (BOOL)validatePassword:(NSString *)passWord;

/// 获取用户基本信息
+ (UserInfoModel *)userInfo;
/// 获取用户详细信息
+ (UserDetailModel *)userDetailInfo;
/// 添加用户信息
+ (void)appendUserInfoWithKey:(NSString *)key value:(NSString *)value;

/// 是否允许开启通知
+ (BOOL)isAllowedNotification;

/// 判断网络状态是否可用
+ (BOOL)isNetworkAvailable;

/// 判断字符串是否为null
+(BOOL)isNullString:(NSString *)string;

///日期转换处理（Date --> yyyy-MM-dd）
+ (NSString *)getYmdFromDate:(NSDate *)date;
/// date --> yyyy-MM-dd HH:mm:ss
+ (NSString *)getDate:(NSDate *)date;
/// 显示几小时前/几天前/几月前/几年前
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;
/// 获取格式为 yyyyMMdd  时间字符串
+ (NSString *)getYYYYmmddDate:(NSDate *)date;
/// 获取当前时间的时间戳
+ (NSString *)getTimeStamp;
/// 时间字符串转为date类型 --> yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateWithDateStr:(NSString *)dateStr;
/// 时间戳转为格式为时间MM-dd HH:mm:ss时间字符串
+ (NSString *)dateStrFromTimeStamp:(NSInteger)timeStamp;
/// 时间字符串 yyyy-MM-dd HH:mm:ss --> 时间字符串 yyyy-MM-dd
+ (NSString *)dateStrFromDateStr:(NSString *)dateStr;
/// 计算某个时间到当前时间的秒数
+ (NSInteger)intervalSinceNow:(NSString *)lateDate;


// 手环相关的存储本地信息
+ (void)setShouHuanMacAddress:(NSString *)macAddress;
+ (void)setShouHuanName:(NSString *)name;
+ (void)setShouHuanUUID:(NSString *)uuid;
+ (void)setShouHuanBoundTime:(NSString *)time;
+ (void)setShouHuanUnbingTime:(NSString *)time;
+ (void)setShouHuanLastTimeSync:(NSString *)time;
+ (void)setShouHuanBoundSteps:(NSInteger)steps;
+ (void)setShouHuanUnbingSteps:(NSString *)steps;
+ (void)setShouHuanLastStepsSync:(NSString *)lastSteps;
+ (void)setUploadServerTime:(NSString *)time;

+ (NSString *)getShouHuanMacSddress;
+ (NSString *)getShouHuanName;
+ (NSString *)getShouHuanUUID;
+ (NSString *)getShouHuanBoundTime;
+ (NSString *)getShouHuanUnbingTime;
+ (NSString *)getShouHuanLastTimeSync;
+ (NSString *)getShouHuanBoundSteps;
+ (NSString *)getShouHuanUnbingSteps;
+ (NSInteger)getShouHuanLastStepsSync;
+ (NSString *)getUploadServerTime;

/// 数据库版本相关
+ (void)saveDataBaseVersion;
+ (NSInteger)getDatabaseVersion;

/// 启动页相关
+ (void)saveLaunchUrl:(NSString *)url;
/// 启动页显示时间
+ (void)saveLaunchDuration:(NSUInteger)duration;
/// 启动时间
+ (void)saveLaunchTime:(NSString *)time;
/// 动态上次显示时间
+ (void)saveDynamicTime:(NSString *)time;
/// 活动上次显示时间
+ (void)saveActivityTime:(NSString *)time;
/// 福利上次显示时间
+ (void)saveShopTime:(NSString *)time;
/// BPush的channel id
+ (void)saveBPushChannelId:(NSString *)channelId;
/// 获取BPush Channel ID
+ (NSString *)getChannelId;
/// 用户是否登陆
+ (BOOL)isLogined;
/// 设置当前项目的根视图
+ (void)setupRootController;

@end
