//
//  VHSURL.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/11.
//  Copyright © 2016年 vhs_health. All rights reserved.
//


// Read Me
/***
*     ----用于统一管理项目的接口定义的URL
****/

#ifndef VHSURL_h
#define VHSURL_h

/***网络环境切换总开关***/

//测试环境
#define GYT_BUILD_FOR_TEST 0

//生产环境
#define GYT_BUILD_FOR_RELEASE

//如果没有打开任何环境那就是测试环境
#if !defined GYT_BUILD_FOR_TEST && !defined GYT_BUILD_FOR_RELEASE && !defined GYT_BUILD_FOR_BATE
#define GYT_BUILD_FOR_TEST
#endif

#ifdef GYT_BUILD_FOR_TEST
//#define kServerURL @"https://vhealthplus.valurise.com/oauth2"
#define kServerURL @"http://118.242.18.199:10000/oauth2"
//#define kServerURL @"http://192.168..72:8080/oauth2"
#endif

#ifdef GYT_BUILD_FOR_BATE
//#define kServerURL @"https://vhealthplus.valurise.com/oauth2"
#define kServerURL @"http://118.242.18.199:10000/oauth2"
//#define kServerURL @"http://192.168.2.72:8080/oauth2"
#endif

/// 福利链接
//static NSString *MAIN_SHOP_URL = @"https://vhealthplus.valurise.com/index.php";
static NSString *MAIN_SHOP_URL = @"http://118.242.18.199:10000/index.php";

/// 活动链接
//static NSString *ACTIVITY_MAIN_URL = @"http://vhealthplus.valurise.com/client/activity/index.htm";
static NSString *ACTIVITY_MAIN_URL = @"http://118.242.18.199:10000/client/activity/index.htm";

#pragma mark - 接口

/// 获取app的启动页
#define URL_GET_APP_START                           @"/getAppStart.htm"
/// 支付
#define URL_GET_PAY_SIGN                            @"/getPaySign.htm"
/// 获取运动的所有步数
#define URL_GET_MEMBER_STEP_KM_LIST                 @"/getMemberStepKmList.htm"
/// 获取发现的icon和title布局
#define URL_GET_DISCOVERY                           @"/getDiscovery.htm"
/// 记录用户拨打电话
#define URL_ADD_PHONE_CALL                          @"/addPhoneCall.htm"
/// 获取动态的banner图片
#define URL_GET_INDEX_BANNER                        @"/getIndexBanner.htm"
/// 获取动态列表信息
#define URL_GET_INDEX_DYNAMIC                       @"/getIndexDynamic.htm"
/// 校验本地和客户端的版本
#define URL_GET_VERSION                             @"/getVersion.htm"
/// 意见反馈
#define URL_ADD_SUGGESTION                          @"/addSuggestion.htm"
/// 手环绑定，解绑 (根据参数判断)
#define URL_DO_HAND_MAC                             @"/doHandMac.htm"
/// 忘记密码-信息修改提交
#define URL_UP_PASSWORD_CODE                        @"/upPasswordCode.htm"
/// 登录
#define URL_LOGIN                                   @"/login.htm"
/// 获取服务器步数(用于数据迁移)
#define URL_GET_MEMBER_STEP                         @"/getMemberStep.htm"
/// 首次登录填写的初始信息
#define URL_ADD_BMI                                 @"/addBMI.htm"
/// 获取用户的积分
#define URL_GET_MEMBER_SCORE                        @"/getMemberScore.htm"
/// 获取用户的详细信息
#define URL_GET_MEMBER_DETAIL                       @"/getMemberDetail.htm"
/// 修改个人信息
#define URL_UP_MEMBER                               @"/upMember.htm"
/// 获取验证码
#define URL_GET_VERCODE                             @"/getVerCode.htm"
/// 获取健康豆兑换比例
#define URL_GET_COMPANY_COLD_RATE                   @"/getCompanyGoldRate.htm"
/// 获取我的积分
#define URL_GET_MEMBER_SCORE_LIST                   @"/getMemberScoreList.htm"
/// 上传头像
#define URL_ADD_HEADER                              @"/addHeader.htm"
/// 退出应用
#define URL_DO_QUIT                                 @"/doQuit.htm"
/// 上传未上传的步数
#define URL_ADD_STEP                                @"/addStep.htm"
/// 引用是否开启推送服务
#define URL_UP_ACCEPT_MSG                           @"/upAcceptMsg.htm"
/// 配置导航栏和Tabbar
#define URL_GET_NAVIGATION                          @"/getNavigation.htm"

#endif /* VHSURL_h */
