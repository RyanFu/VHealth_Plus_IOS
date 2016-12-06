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

#pragma mark - Toast -=========================Toast 提示语===================

#define TOAST_NO_NETWORK                                @"网络未连接"
#define TOAST_NETWORK_SUSPEND                           @"连接超时，请重试"
#define TOAST_NOMORE_DATA                               @"已全部显示"
#define TOAST_UPLOAD_STEPS_SUCCESS                      @"同步成功"
#define TOAST_UPLOAD_SETPS_FAIL                         @"同步失败"
#define TOAST_BLE_BIND_NO_NOTWORK                       @"绑定手环需要网络"
#define TOAST_BLE_BIND_SUCCESS                          @"绑定成功"
#define TOAST_BLE_BIND_FAIL                             @"绑定失败，请重试"
#define TOAST_BLE_UNBIND_SUCCESS                        @"解绑成功"
#define TOAST_BLE_UNBIND_FAIL                           @"解绑失败"
#define TOAST_UNFINISH_USER_INFO                        @"请完善所有信息"
#define TOAST_UNFINISH_FEEDBACK_INFO                    @"请填写您的反馈内容"


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

#pragma mark - URL =====================================HTML的URL===============================

#define k_LaunchUrl                                     @"k_LaunchUrl"                      // 启动页的Url


#pragma mark - NSNotification ============================通知=====================================

#define k_NOTIFICATION_TOKEN_INVALID                    @"k_NOTIFICATION_TOKEN_INVALID"         // token 失效通知
#define k_NOTI_ALIPAY_CALLBACK_INFO                     @"k_NOTIFICATION_ALIPAY_CALLBACK_INFO"  // 调用支付客户端后的回调信息
#define k_NOTI_WXPAY_CALLBACK_INFO                      @"k_NOTI_WXPAY_CALLBACK_INFO"           // 微信支付后回调信息
#define k_NOTI_DIDBINDED_BLE                            @"k_NOTI_DIDBINDED_BLE"                 // 手机已经绑定手环
#define k_NOTI_SYNCSTEPS_TO_NET                         @"k_NOTI_SYNCSTEPS_TO_NET"              // 自动同步步数数据到云端


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



#endif /* VHSDefinition_h */
