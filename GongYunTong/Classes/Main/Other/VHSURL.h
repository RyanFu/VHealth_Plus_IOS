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

//生产环境
#define VHEALTH_BUILD_FOR_RELEASE 0

#if VHEALTH_BUILD_FOR_RELEASE

static NSString * const kServerURL          = @"https://vhealthplus.valurise.com/oauth2";
static NSString * const MAIN_SHOP_URL       = @"https://vhealthplus.valurise.com/index.php"; // 福利地址
static NSString * const ACTIVITY_MAIN_URL   = @"http://vhealthplus.valurise.com/client/activity/index.htm"; // 活动地址

#else

static NSString * const kServerURL          = @"http://118.242.18.199:10000/oauth2";
static NSString * const MAIN_SHOP_URL       = @"http://118.242.18.199:10000/index.php"; // 福利地址
static NSString * const ACTIVITY_MAIN_URL   = @"http://118.242.18.199:10000/client/activity/index.htm";  // 活动地址

//#define kServerURL @"http://192.168.2.24:8000/oauth2"
//static NSString *MAIN_SHOP_URL = @"http://192.168.2.24:8000/index.php"; // 福利地址
//static NSString *ACTIVITY_MAIN_URL = @"http://192.168.2.24:8000/client/activity/index.htm";  // 活动地址

#endif

#pragma mark - 接口

/// 获取app的启动页
static NSString * const URL_GET_APP_START           = @"/getAppStart.htm";
/// 获取运动的所有步数
static NSString * const URL_GET_MEMBER_STEP_KM_LIST = @"/getMemberStepKmList.htm";
/// 获取发现的icon和title布局
static NSString * const URL_GET_DISCOVERY           = @"/getDiscovery.htm";
/// 记录用户拨打电话
static NSString * const URL_ADD_PHONE_CALL          = @"/addPhoneCall.htm";
/// 获取动态的banner图片
static NSString * const URL_GET_INDEX_BANNER        = @"/getIndexBanner.htm";
/// 获取动态列表信息
static NSString * const URL_GET_INDEX_DYNAMIC       = @"/getIndexDynamic.htm";
/// 校验本地和客户端的版本
static NSString * const URL_GET_VERSION             = @"/getVersion.htm";
/// 意见反馈
static NSString * const URL_ADD_SUGGESTION          = @"/addSuggestion.htm";
/// 手环绑定，解绑 (根据参数判断)
static NSString * const URL_DO_HAND_MAC             = @"/doHandMac.htm";
/// 忘记密码-信息修改提交
static NSString * const URL_UP_PASSWORD_CODE        = @"/upPasswordCode.htm";
/// 登录
static NSString * const URL_LOGIN                   = @"/login.htm";
/// 获取服务器步数(用于数据迁移)
static NSString * const URL_GET_MEMBER_STEP         = @"/getMemberStep.htm";
/// 首次登录填写的初始信息
static NSString * const URL_ADD_BMI                 = @"/addBMI.htm";
/// 获取用户的积分
static NSString * const URL_GET_MEMBER_SCORE        = @"/getMemberScore.htm";
/// 获取用户的详细信息
static NSString * const URL_GET_MEMBER_DETAIL       = @"/getMemberDetail.htm";
/// 修改个人信息
static NSString * const URL_UP_MEMBER               = @"/upMember.htm";
/// 获取验证码
static NSString * const URL_GET_VERCODE             = @"/getVerCode.htm";
/// 获取健康豆兑换比例
static NSString * const URL_GET_COMPANY_COLD_RATE   = @"/getCompanyGoldRate.htm";
/// 获取我的积分
static NSString * const URL_GET_MEMBER_SCORE_LIST   = @"/getMemberScoreList.htm";
/// 上传头像
static NSString * const URL_ADD_HEADER              = @"/addHeader.htm";
/// 退出应用
static NSString * const URL_DO_QUIT                 = @"/doQuit.htm";
/// 上传未上传的步数
static NSString * const URL_ADD_STEP                = @"/addStep.htm";
/// 引用是否开启推送服务
static NSString * const URL_UP_ACCEPT_MSG           = @"/upAcceptMsg.htm";
/// 配置导航栏和Tabbar
static NSString * const URL_GET_NAVIGATION          = @"/getNavigation.htm";
/// 获取首页导航的Icon列表
static NSString * const URL_GET_ICON                = @"/getIcon.htm";
/// 签到
static NSString * const URL_ADD_CHECKIN_DAY         = @"/addCheckinDay.htm";
/// 支付宝，获取订单签名信息
static NSString * const URL_GET_PAY_SIGN            = @"/getPaySign.htm";
/// 获取俱乐部列表
static NSString * const URL_GET_CLUB_LIST           = @"/getClubList.htm";
/// 获取俱乐部成员
static NSString * const URL_GET_CLUB_MEMBER_LIST    = @"/getClubMemberList.htm";
/// 俱乐部添加帖子
static NSString * const URL_ADD_CLUB_BBS            = @"/addClubbbs.htm";
/// 退出俱乐部
static NSString * const URL_DO_CLUB_QUIT            = @"/doClubQuit.htm";
/// 帖子回复
static NSString * const URL_ADD_CLUB_BBS_REPLY      = @"/addClubbbsReply.htm";
/// 发布公告
static NSString * const URL_ADD_CLUB_NOTICE         = @"/addClubNotice.htm";
/// 编辑公告
static NSString * const URL_UP_CLUB_NOTICE          = @"/upClubNotice.htm";
/// 获取俱乐部更多列表
static NSString * const URL_GET_CLUB_MORE           = @"/getClubMore.htm";
/// 获取最新的公告列表
static NSString * const URL_GET_NEW_CLUB_NOTICE     = @"/getNewClubNotice.htm";
/// 获取推送消息列表信息
static NSString * const URL_GET_MESSAGE_QUEUE       = @"/getMessageQueue.htm";

#endif /* VHSURL_h */
