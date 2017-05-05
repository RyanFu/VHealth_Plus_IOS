//
//  ThirdPartyCoordinator.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/22.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "ThirdPartyCoordinator.h"
#import "BPush.h"
#import "BaiduMobStat.h"
#import <UserNotifications/UserNotifications.h>
#import <RongIMKit/RongIMKit.h>

@interface ThirdPartyCoordinator ()<RCIMUserInfoDataSource, /*RCIMReceiveMessageDelegate,*/ RCIMGroupInfoDataSource>

@end

/***百度统计***/
static NSString * const BaiduMob_APP_KEY = @"a3bd4374ec";
static NSString * const BaiduMob_ChannelId = @"vhs_vhealth_plus_release";
/***JSPatch热修复***/
static NSString * const JSPatch_APPKey = @"1b4681673bab1e48";
/***百度推送相关***/
static NSString * const Baidu_Push_AppId = @"8661968";
static NSString * const Baidu_Push_ApiKey = @"VGffpOhKOUU9XHoSms220a93";
static NSString * const Baidu_Push_SecretKey = @"5WQLtDBbk4K2G9fRcR5CNYs3m9kKSMmo";

@implementation ThirdPartyCoordinator

+ (ThirdPartyCoordinator *)shareCoordinator {
    static ThirdPartyCoordinator *coordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coordinator = [[ThirdPartyCoordinator alloc] init];
    });
    return coordinator;
}

#pragma mark - 百度统计

// 启动百度移动统计
- (void)startBaiduMobileStat {
    /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
     NSAppTransportSecurity(NSDictionary):
     NSAllowsArbitraryLoads(Boolen):YES
     详情参考本Demo的BaiduMobStatSample-Info.plist文件中的配置
     */
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [VHSCommon appVersion];
    statTracker.channelId = BaiduMob_ChannelId;
    statTracker.enableExceptionLog = YES;
    statTracker.enableDebugOn = NO;
    [statTracker startWithAppId:BaiduMob_APP_KEY]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

#pragma mark - 百度推送

/// 百度推送
- (void)startBaiDuPush:(UIApplication *)application launchingWithOptions:(NSDictionary *)launchOptions {
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [application registerForRemoteNotifications];
            }
        }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    BPushMode model = BPushModeProduction;
    if (!BUILD_FOR_RELEASE) model = BPushModeDevelopment;
    
    [BPush registerChannel:launchOptions
                    apiKey:Baidu_Push_ApiKey
                  pushMode:model
           withFirstAction:@"打开"
          withSecondAction:@"关闭"
              withCategory:nil
      useBehaviorTextInput:NO
                   isDebug:NO];
    
    // 禁用地理位置推送 需要再绑定接口前调用。
    [BPush disableLbs];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - 融云

#if BUILD_FOR_RELEASE
    static NSString * const RCIM_APPKEY = @"lmxuhwaglmf6d";
#else
    static NSString * const RCIM_APPKEY = @"8brlm7uf8bxo3";
#endif

- (void)setupRCKit {
    NSString *rongcloudToken = [VHSCommon userInfo].rongcloudToken;
    if ([VHSCommon isNullString:rongcloudToken]) {
        return;
    }
    
    [[RCIM sharedRCIM] initWithAppKey:RCIM_APPKEY];
    [[RCIM sharedRCIM] connectWithToken:rongcloudToken success:^(NSString *userId) {
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
//        [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];//RCIMGroupInfoDataSource
    } error:^(RCConnectErrorCode status) {
        CLog(@"登陆的错误码为:%d", (int)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        CLog(@"token错误");
    }];
}

// 代理用户信息 - 自定义聊天用户信息显示
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
    NSArray *clubMemberList = [VHSCommon getUserDefautForKey:k_CLUB_MEMBERS_LIST];
    
    if ([clubMemberList count] <= 0) return completion(nil);
    
    for (NSDictionary *dict in clubMemberList) {
        if ([userId isEqualToString:[dict[@"memberId"] stringValue]]) {
            RCUserInfo *info = [[RCUserInfo alloc] init];
            info.userId = userId;
            info.name = dict[@"name"];
            info.portraitUri = dict[@"headerUrl"];
            return completion(info);
        }
    }
    return completion(nil);
}

// 代理-应用在前台时候，取消声音提醒
- (BOOL)onRCIMCustomAlertSound:(RCMessage*)message {
    return YES;
}

// 代理-实现应用在后台2分钟内，实现本地推送
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    NSArray *clubList = [VHSCommon getUserDefautForKey:k_CLUB_MY_TYPE_LIST];
    for (NSDictionary *dict in clubList) {
        if ([dict[@"rongGroupId"] isEqualToString:groupId]){
            RCGroup *group = [[RCGroup alloc] initWithGroupId:groupId groupName:dict[@"clubName"] portraitUri:dict[@"coverUrl"]];
            completion(group);
            break;
        }
    }
}

@end
