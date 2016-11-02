//
//  VHSCommon.h
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "UserDetailModel.h"


/***网络环境切换总开关***/

//测试环境
#define GYT_BUILD_FOR_TEST 0

//生产环境
#define GYT_BUILD_FOR_RELEASE

//如果没有打开任何环境那就是测试环境
#if !defined GYT_BUILD_FOR_TEST && !defined GYT_BUILD_FOR_RELEASE && !defined GYT_BUILD_FOR_BATE
#define GYT_BUILD_FOR_TEST
#endif

/***end***/

// http://118.242.18.199:10000


#ifdef GYT_BUILD_FOR_TEST
#define kServerURL @"http://118.242.18.199:10000/oauth2"
//#define kServerURL @"http://192.168.2.30:8080/oauth2"
//#define kServerURL @"https://kldf.dfzq.com.cn/oauth2"
#endif

#ifdef GYT_BUILD_FOR_BATE
#define kServerURL @"http://118.242.18.199:10000/oauth2"
//#define kServerUrl @"http://192.168.2.30:8080/oauth2"
//#define kServerURL @"https://kldf.dfzq.com.cn/oauth2"
#endif

//#ifdef GYT_BUILD_FOR_RELEASE
//#define kServerURL @"http://118.242.18.199:10000/oauth2"
//#define kServerURL @"https://kldf.dfzq.com.cn/oauth2"
//#endif

/// 配置支付宝相关
#define ALIPAY_APP_SCHEME     @"VHSgongyuntong"

// 设备iphone4
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/// 屏幕宽
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
/// 屏幕高
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height

#define RATIO(x)    x / SCREEN_WIDTH

//系统版本
#define IOS_7 [[UIDevice currentDevice].systemVersion floatValue]>= 7.0
#define IOS_8 [[UIDevice currentDevice].systemVersion floatValue]>= 8.0
#define IOS_9 [[UIDevice currentDevice].systemVersion floatValue]>= 9.0

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

///const 通知key
extern NSString *const DeviceDidScanBLEsNotification;    //扫描到手环通知
extern NSString *const DeviceDidScanBLEsUserInfoKey;     //扫描到手环通知里userinfo的key
extern NSString *const DeviceDidConnectedBLEsNotification;   //与手环连接成功通知
extern NSString *const DeviceDidConnectedBLEsUserInfoPeripheral;   //与手环连接成功通知里userinfo的key

@interface VHSCommon : NSObject

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
/// 获取uuid
+ (NSString *)deviceToken;
/// 获取手机型号
+ (NSString *)phoneModel;
/// AppStore更新应用
+ (void)toAppStoreForUpgrade;
/// 获取vhstoken
+ (NSString *)vhstoken;
/// 获取本地经纬度
+ (NSString *)latitudeLongitude;
/// 移除本地用户信息 － 包括缓存
+ (void)removeLocationUserInfo;

/// 使用UserDefault保存信息
+ (void)saveUserDefault:(id)value forKey:(NSString *)key;
/// 从UserDefault中获取信息
+ (id)getUserDefautForKey:(NSString *)key;

// 校验简单密码
+ (BOOL)validatePassword:(NSString *)passWord;

/// 获取用户基本信息
+ (UserInfoModel *)userInfo;
/// 获取用户详细信息
+ (UserDetailModel *)userDetailInfo;

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
+ (void)setShouHuanConnectedTime:(NSString *)time;
+ (void)setShouHuanBoundTime:(NSString *)time;
+ (void)setShouHuanUnbingTime:(NSString *)time;
+ (void)setShouHuanLastTimeSync:(NSString *)time;
+ (void)setShouHuanBoundSteps:(NSInteger)steps;
+ (void)setShouHuanUnbingSteps:(NSString *)steps;
+ (void)setShouHuanLastStepsSync:(NSInteger)lastSteps;
+ (void)setUploadServerTime:(NSString *)time;

+ (NSString *)getShouHuanMacSddress;
+ (NSString *)getShouHuanName;
+ (NSString *)getShouHuanUUID;
+ (NSString *)getShouHuanConnectedTime;
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

@end
