//
//  VHSCommon.h
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 lucky. All rights reserved.
//  修改

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "UserDetailModel.h"

// 设备iphone4
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define ratioW SCREENW / 375.0
#define ratioH SCREENH / 667.0

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

@property (strong, nonatomic) UserInfoModel *userInfo;

+ (instancetype)share;

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
/// 获取uuid
+ (NSString *)deviceToken;
/// 获取手机型号
+ (NSString *)phoneModel;
/// 获取手机对外的回调
+ (NSString *)appSecheme;
/// 获取百度推送的AppKey
+ (NSString *)BPushAPPKey;
/// 获取融云的AppKey
+ (NSString *)RCIMAppKey;
/// 获取百度统计AppKey
+ (NSString *)BaiduMobAPPKey;
/// 获取百度统计ChannelId
+ (NSString *)BaiduMobChannelId;
/// 通过URL打开一个新的窗口，一般的URL开大Safari应用url打开AppStore
+ (void)openWindowWithUrl:(NSString *)urlStr;
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
/// 删除UserDefault信息
+ (void)removeUserDefaultForKey:(NSString *)key;

// 校验简单密码
+ (BOOL)validatePassword:(NSString *)passWord;
/// 添加用户信息
+ (void)appendUserInfoWithKey:(NSString *)key value:(NSString *)value;
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
/// 时间格式转换yyyyMMdd --> yyyy-MM-dd
+ (NSString *)dateStrFromYYYYMMDD:(NSString *)yyyyMMdd;
/// 时间格式转换yyyyMMdd --> yyyy-MM-dd HH:mm:ss
+ (NSString *)dateStrFromYYYYMMDDToDate:(NSString *)yyyyMMdd;
/// 计算某个时间到当前时间的秒数
+ (NSInteger)intervalSinceNow:(NSString *)lateDate;
/// 判断凌晨时刻5分钟范围
+ (BOOL)isBetweenZeroMomentFiveMinute;
/// 获取15天以前的时间
+ (NSString *)getBeforeFifteenDay;


// 手环相关的存储本地信息
+ (void)setShouHuanMacAddress:(NSString *)macAddress;
+ (void)setShouHuanUUID:(NSString *)uuid;
+ (void)setShouHuanBoundTime:(NSString *)time;
+ (void)setShouHuanLastTimeSync:(NSString *)time;
+ (void)setUploadServerTime:(NSString *)time;

+ (NSString *)getShouHuanMacAddress;
+ (NSString *)getShouHuanName;
+ (NSString *)getShouHuanUUID;
+ (NSString *)getShouHuanBoundTime;
+ (NSString *)getShouHuanLastTimeSync;
+ (NSString *)getUploadServerTime;

/// 启动页相关
+ (void)saveLaunchUrl:(NSString *)url;
/// 启动时间
+ (void)saveLaunchTime:(NSString *)time;
/// 启动页显示时间
+ (void)saveLaunchDuration:(NSUInteger)duration;
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
/// 获取卡路里
+ (double)getCalorieBySteps:(NSInteger)steps;
/// 设置当前项目的根视图
+ (void)setupRootController;

@end
