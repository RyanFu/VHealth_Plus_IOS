//
//  VHSDefinition.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#ifndef VHSDefinition_h
#define VHSDefinition_h

#define mark - 缓存 ======================

#define Cache_Dynamic_BannerList                @"Cache_Dynamic_BannerList"     // 动态banner缓存
#define Cache_Dynamic_DynamicList               @"Cache_Dynamic_DynamicList"    // 动态列表缓存
#define Cache_Discover_BannerList               @"Cache_Discover_BannerList"    // 发现
#define Cache_Me_UserScore                      @"Cache_Me_UserScore"           // 我
#define Cache_Config_NavOrTabbar                @"Cache_Config_NavOrTabbar"     // 导航栏和状态栏
#define Cache_Config_Icon                       @"Cache_Config_Icon"            // 缓存首页中icon的配置

#pragma mark - Toast -=========================Toast 提示语===================

static NSString * const TOAST_NO_NETWORK                = @"网络未连接";
static NSString * const TOAST_NETWORK_SUSPEND           = @"连接超时，请重试";
static NSString * const TOAST_NOMORE_DATA               = @"已全部显示";
static NSString * const TOAST_UPLOAD_STEPS_SUCCESS      = @"同步成功";
static NSString * const TOAST_UPLOAD_SETPS_FAIL         = @"同步失败";
static NSString * const TOAST_BLE_BIND_NO_NOTWORK       = @"绑定手环需要网络";
static NSString * const TOAST_BLE_BIND_SUCCESS          = @"绑定成功";
static NSString * const TOAST_BLE_BIND_FAIL             = @"绑定失败，请重试";
static NSString * const TOAST_BLE_UNBIND_SUCCESS        = @"解绑成功";
static NSString * const TOAST_BLE_UNBIND_FAIL           = @"解绑失败";
static NSString * const TOAST_UNFINISH_USER_INFO        = @"请完善所有信息";
static NSString * const TOAST_UNFINISH_FEEDBACK_INFO    = @"请填写您的反馈内容";
static NSString * const TOAST_SIGN_SUCCESS              = @"签到成功";
static NSString * const TOAST_SIGN_FAILURE              = @"签到失败";
static NSString * const TOAST_CLUB_BBS_POSTING          = @"帖子发送中";
static NSString * const TOAST_CLUB_NOTICE_POSTING       = @"公告发布中";
static NSString * const TOAST_CLUB_REPLYING             = @"回复中";
static NSString * const TOAST_NEED_INPUT_MOBILE         = @"请输入手机号";
static NSString * const TOAST_NEED_INPUT_VERCODE        = @"请输入验证码";

#pragma mark - 全局使用的汉字文本

static NSString * const CONST_CLUB_MOMENT_POST_PLACEHOLDER          = @"说点什么吧...";
static NSString * const CONST_CLUB_CONFIRM_DO_QUIT                  = @"确定退出俱乐部";
static NSString * const CONST_PROMPT_MESSAGE                        = @"提示";
static NSString * const CONST_CONFIRM                               = @"确定";
static NSString * const CONST_CANCLE                                = @"取消";
static NSString * const CONST_CLUB_ADD_BBS                          = @"发帖子";
static NSString * const CONST_CLUB_ADD_NOTICE                       = @"发公告";
static NSString * const CONST_REPLY                                 = @"回复";
static NSString * const CONST_EDIT_NOTICE                           = @"编辑公告";
static NSString * const CONST_OPEN_ACCOUNT_SUCCESS                  = @"开通账号成功";

#pragma mark - App中的常量

static NSString *const CONST_GET_DATA_FROM_BRACELET             = @"获取设备数据到手机";


#pragma mark - 状态码的定义 ==============================状态码=====================================

#define GYT_CODE_SUCCESS                            200
#define GYT_CODE_TOKEN_INVALID                      4000

#pragma mark - APP全局字段 ==============================字段=====================================

#define k_VHS_DataBase_Version_Key                      @"database_version"
#define k_VHS_DataBase_Version                          1
#define k_LATITUDE_LONGITUDE                            @"k_LATITUDE_LONGITUDE"             // 经纬度
#define k_Launch_Time                                   @"k_Launch_Time"                    // 记录启动的时间
#define k_Late_Duration(x)                              x * 3600                                    
#define k_Late_Show_Dynamic_Time                        @"k_Late_Show_Dynamic_Time"         // 动态上次显示时间
#define k_Late_Show_Activity_Time                       @"k_Late_Show_Activity_Time"        // 活动上次显示时间
#define k_Late_Show_Shop_Time                           @"k_Late_Show_Shop_Time"            // 福利上次显示时间
#define k_REFRESH_TIME_OUT                              10                                  // 下拉刷新超时时间

/// 俱乐部
#define k_CLUB_MEMBERS_LIST                             @"k_CLUB_MEMBERS_LIST"              // 俱乐部成员列表

#pragma mark - URL =====================================HTML的URL===============================

#define k_LaunchUrl                                     @"k_LaunchUrl"                      // 启动页的Url


#pragma mark - NSNotification ============================通知=====================================

#define k_NOTIFICATION_TOKEN_INVALID                    @"k_NOTIFICATION_TOKEN_INVALID"         // token 失效通知
#define k_NOTI_ALIPAY_CALLBACK_INFO                     @"k_NOTIFICATION_ALIPAY_CALLBACK_INFO"  // 调用支付客户端后的回调信息
#define k_NOTI_WXPAY_CALLBACK_INFO                      @"k_NOTI_WXPAY_CALLBACK_INFO"           // 微信支付后回调信息
#define k_NOTI_DIDBINDED_BLE                            @"k_NOTI_DIDBINDED_BLE"                 // 手机已经绑定手环
#define k_NOTI_SYNCSTEPS_TO_NET                         @"k_NOTI_SYNCSTEPS_TO_NET"              // 自动同步步数数据到云端
#define k_NOTI_DOUBLE_CLICK_TABBAR                      @"k_NOTI_DOUBLE_CLICK_TABBAR"           // 双击tabbar的item


#pragma mark - NSUserDefault =============================本地存储=================================

// app 登录相关信息
#define k_VHS_Token                                     @"vhstoken"

#define k_User_Detail_Info                              @"k_User_Detail_Info"
#define k_User_Name                                     @"k_User_Name"
#define k_Steps_To_Kilometre_Ratio                      @"k_Steps_To_Kilometre_Ratio"   /// 步数和公里转换系数
#define k_LOGIN_NUMBERS                                 @"k_LOGIN_NUMBERS"              /// 登录次数

/// 定义手环相关本地标识
#define k_SHOUHUAN_MAC_ADDRESS                          @"k_SHOUHUAN_MAC_ADDRESS"       /// 手环mac地址
#define k_SHOUHUAN_NAME                                 @"k_SHOUHUAN_NAME"              /// 手环名称
#define k_SHOUHUAN_UUID                                 @"k_SHOUHUAN_UUID"              /// 手环UUID
#define k_SHOUHUAN_CONNECTED_TIME                       @"k_SHOUHUAN_CONNECTED_TIME"    /// 手环连接时间
#define k_SHOUHUAN_BOUND_TIME                           @"k_SHOUHUAN_BOUND_TIME"        /// 手环绑定时间
#define k_SHOUHUAN_UNBING_TIME                          @"k_SHOUHUAN_UNBING_TIME"       /// 手环解绑时间
#define k_SHOUHUAN_LAST_TIME_SYNC                       @"k_SHOUHUAN_LAST_TIME_SYNC"    /// 手环最新一次同步的时间
#define k_SHOUHUAN_LAST_STEPS_SYNC                      @"k_SHOUHUAN_LAST_STEPS_SYNC"   /// 手环最新同步时的步数
#define k_SHOUHUAN_BOUND_STEPS                          @"k_SHOUHUAN_BOUND_STEPS"       /// 手环绑定时步数
#define k_SHOUHUAN_UNBING_STEPS                         @"k_SHOUHUAN_UNBING_STEPS"      /// 手环解绑时步数
#define k_SHOUHUAN_IS_BIND                              @"k_SHOUHUAN_IS_BIND"           /// 手环是否绑定

#define k_SHOUHUAN_UNBING_MOBILE_STEPS                  @"k_SHOUHUAN_UNBING_MOBILE_STEPS"   /// 手环解绑时候当是手机的步数
#define k_UPLOAD_TO_SERVER_TIME                         @"k_UPLOAD_TO_SERVER_TIME"          /// 本地数据同步到服务器时间

#define k_M7_MOBILE_SYNC_STEPS                          @"k_M7_MOBILE_SYNC_STEPS"           /// M7谐处理器同步时候的步数
#define k_M7_MOBILE_SYNC_TIME                           @"k_M7_MOBILE_SYNC_TIME"            /// M7同步的时间

#define k_BPush_Channel_id                              @"k_BPush_Channel_id"               /// 百度推送的channel id

#define k_TIMETASK_START_DAY                            @"k_TIMETASK_START_DAY"             /// 开始日期
#define k_TIMETASK_END_DAY                              @"k_TIMETASK_END_DAY"               /// 结束日期
#define k_TIMETASK_START_TIME                           @"k_TIMETASK_START_TIME"            /// 每天开始的时间
#define k_TIMETASK_END_TIME                             @"k_TIMETASK_END_TIME"              /// 每天结束的时间



#endif /* VHSDefinition_h */
