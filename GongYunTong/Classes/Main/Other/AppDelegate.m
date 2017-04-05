//
//  AppDelegate.m
//  GongYunTong
//
//  Created by vhsben on 16/7/15.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "AppDelegate.h"
#import "VHSStepAlgorithm.h"
#import "VHSFitBraceletStateManager.h"
#import "MBProgressHUD+VHS.h"
#import "NSDate+VHSExtension.h"
#import "ShortcutItem.h"
#import "VHSTabBarController.h"
#import "ThirdPartyCoordinator.h"
#import "BPush.h"

static BOOL isBackGroundActivateApplication;

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIApplication Did Finish Launching

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 百度统计
    [[ThirdPartyCoordinator shareCoordinator] startBaiduMobileStat];
    // 开启百度推送
    [[ThirdPartyCoordinator shareCoordinator] startBaiDuPush:application launchingWithOptions:launchOptions];
    // 融云SDK初始化
    [[ThirdPartyCoordinator shareCoordinator] setupRCKit];
    
    // 创建数据库，开启计步模式
    [[VHSStepAlgorithm shareAlgorithm] setupStepRecorder];
    
    // 启动时间
    [VHSCommon saveLaunchTime:[VHSCommon getDate:[NSDate date]]];
    
    // 设置3D Touch，仅支持iPhone6s之上
//    if (![application.shortcutItems count]) {
//        [[ShortcutItem defaultShortcutItem] configShortcutItemApplication:application];
//    }
    
    return YES;
}

#pragma mark - AppPay

/// 处理支付宝或分享结果
/// iOS4.x - iOS9.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([ALIPAY_APP_SCHEME isEqualToString:url.scheme]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [k_NotificationCenter postNotificationName:k_NOTI_ALIPAY_CALLBACK_INFO object:self userInfo:resultDic];
        }];
        return YES;
    }
    return YES;
}

// iOS9 之后出现app之间进行跳转到api
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0) {
    if ([ALIPAY_APP_SCHEME isEqualToString:url.scheme]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [k_NotificationCenter postNotificationName:k_NOTI_ALIPAY_CALLBACK_INFO object:self userInfo:resultDic];
        }];
        return YES;
    }
    return YES;
}

#pragma mark - 远程通知

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    // 消息计数器计数
    [[VHSGlobalDataManager shareGlobalDataManager].messageCounter increase:MessageCounterTextType];
    
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    } else if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication) {
        // 应用在杀死状态下，直接跳转到跳转页面。
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    } else if (application.applicationState == UIApplicationStateInactive && isBackGroundActivateApplication) {
        // 应用挂起在后台
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 应用在后台，只有在静默推送才会激活该选项，后台设置aps字段里的content-available 值为 1
        // 此处可以选择激活应用提前下载邮件图片等内容。
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
    
    // 推送链接是否支持跳转
    NSString *pushMessage = userInfo[@"aps"][@"alert"];
    [VHSUtils smartJumpWithUrlString:pushMessage completionHandler:^(NSString *url) {
        UIViewController *topVC = [VHSUtils getCurrentController];
        
        if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication) {
            // 应用在杀死状态下，直接跳转到跳转页面。
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self topController:topVC pushWithUrl:url];
            });
        } else if (application.applicationState == UIApplicationStateInactive && isBackGroundActivateApplication) {
            // 应用挂起在后台
            [self topController:topVC pushWithUrl:url];
        }
    }];
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [BPush registerDeviceToken:deviceToken];
    // 需要在绑定成功后进行 settag listtag delete tag unbind 操作否则会失败
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (error) return;
        if (result) {
            // 获取channel_id
            [VHSCommon saveBPushChannelId:[BPush getChannelId]];
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {}];
            [BPush setTag:@"vhs_gyt_tags" withCompleteHandler:^(id result, NSError *error) {}];
        }
    }];
    
    // 融云消息提醒
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    CLog(@"--->>> deviceToken获取失败%@",error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}


#pragma mark - 系统通知

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // 进入前台，消除所有Badge Number
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSString *adTime = [VHSCommon getUserDefautForKey:k_Launch_Time];
    
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    // 没有公司编号 显示启动页的时间小于一个小时
    if (!companyId || [VHSCommon intervalSinceNow:adTime] < k_Late_Duration(1.0)) return;
    
    NSString *luanchUrl = [VHSCommon getUserDefautForKey:k_LaunchUrl];
    if (!luanchUrl) {
        [self downloadLaunchUrl:^(NSString *url) {[VHSCommon showADPageWithUrl:url duration:2.0];}];
    } else {
        [VHSCommon showADPageWithUrl:luanchUrl duration:2.0];
    }
}

- (void)downloadLaunchUrl:(void (^)(NSString *url))success {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_APP_START;
    message.httpMethod = VHSNetworkGET;
    
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if (![VHSCommon isNullString:companyId]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:companyId forKey:@"companyId"];
        message.params = dic;
    }
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        NSString *launchUrl = result[@"startUrl"];
        [VHSCommon saveLaunchUrl:launchUrl];
        if (success) success(launchUrl);
    } fail:^(NSError *error) {}];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 保存进入应用后台的时间
    [VHSCommon saveLaunchTime:[VHSCommon getDate:[NSDate date]]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    isBackGroundActivateApplication = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {
        // 同步手环数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[VHSStepAlgorithm shareAlgorithm] asynDataFromBraceletToMobileDB:^{
                [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:nil];
                [k_NotificationCenter postNotificationName:k_NOTI_SYNCSTEPS_TO_NET object:self];
            }];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:nil];
            [k_NotificationCenter postNotificationName:k_NOTI_SYNCSTEPS_TO_NET object:self];
        });
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

//内存警告
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    DLog(@"内存警告");
}

#pragma mark - UIApplicationShortcut Item Handle

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    // 根据不一样的shortcut处理不一样的事件
    if (shortcutItem) {
        if ([shortcutItem.type isEqualToString:@"vhealth_plus_share"]) {
            NSArray *arr = @[@"share"];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:arr applicationActivities:nil];
            [self.window.rootViewController presentViewController:activityVC animated:YES completion:nil];
            
            if (completionHandler) completionHandler(NO);
        }
    }
    
    if (completionHandler) completionHandler(YES);
}

- (void)topController:(UIViewController *)topVC pushWithUrl:(NSString *)url {
    if (url) {
        PublicWKWebViewController *web = [[PublicWKWebViewController alloc] init];
        web.urlString = url;
        web.hidesBottomBarWhenPushed = YES;
        [topVC.navigationController pushViewController:web animated:YES];
    } else {
        VHSMessageQueueController *msgQueueVC = [[VHSMessageQueueController alloc] init];
        msgQueueVC.hidesBottomBarWhenPushed = YES;
        [topVC.navigationController pushViewController:msgQueueVC animated:YES];
    }
}

@end
