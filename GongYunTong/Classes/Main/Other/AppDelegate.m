
//
//  AppDelegate.m
//  GongYunTong
//
//  Created by vhsben on 16/7/15.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "AppDelegate.h"
#import "VHSStepAlgorithm.h"
#import "VHSFitBraceletStateManager.h"
#import "MBProgressHUD+VHS.h"
//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>
#import <UserNotifications/UserNotifications.h>
#import "VHSStartController.h"
#import "NSDate+VHSExtension.h"
#import "BaiduMobStat.h"
#import "BPush.h"

static BOOL isBackGroundActivateApplication;

typedef NS_ENUM(NSInteger, TimerType)
{
    TimerTypeOfBleToMobile = 1,     // 定时器从手环同步数据到手机
    TimerTypeOfMobileToNetwork      // 从手机同步到服务器
};

@interface AppDelegate ()<AsdkBleModuleDelegate>
{
    UIView *adView;
}

@property (nonatomic, strong) dispatch_source_t mobileTimer;
@property (nonatomic, strong) dispatch_source_t bleTimer;

// 外围设备对象
@property(nonatomic,strong)CBPeripheral *BLEPeripheral;

@end

/***蒲公英***/
static NSString *PGY_APP_ID = @"63566aa74651a92a8a767c452e3fc876";
/***百度统计***/
static NSString *BaiduMob_APP_KEY = @"a3bd4374ec";
/***百度推送相关***/
static NSString *Baidu_Push_AppId = @"8661968";
static NSString *Baidu_Push_ApiKey = @"VGffpOhKOUU9XHoSms220a93";
static NSString *Baidu_Push_SecretKey = @"5WQLtDBbk4K2G9fRcR5CNYs3m9kKSMmo";

@implementation AppDelegate

#pragma mark - override getter method 

-(NSMutableArray *)peripherals {
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

#pragma mark - 百度统计
// 启动百度移动统计
- (void)startBaiduMobileStat{
    /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
     NSAppTransportSecurity(NSDictionary):
     NSAllowsArbitraryLoads(Boolen):YES
     详情参考本Demo的BaiduMobStatSample-Info.plist文件中的配置
     */
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.channelId = @"vhs_gyt_dev";
    statTracker.enableExceptionLog = YES;
    statTracker.enableDebugOn = NO;
    [statTracker startWithAppId:BaiduMob_APP_KEY]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

//#pragma mark - 蒲公英
//
//- (void)startPGY {
//    // 启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
//    // 启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
//}

#pragma mark - 百度推送

- (void)startBaiDuPush:(UIApplication *)application launchingWithOptions:(NSDictionary *)launchOptions {
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
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
    [BPush registerChannel:launchOptions apiKey:Baidu_Push_ApiKey pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    
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

#pragma mark - applicaion did launch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self startPGY];
    [self startBaiduMobileStat];
    [self startBaiDuPush:application launchingWithOptions:launchOptions];
    
    [[VHSStepAlgorithm shareAlgorithm] start];
    
    // 启动时间
    [VHSCommon saveLaunchTime:[VHSCommon getDate:[NSDate date]]];
    
    return YES;
}

#pragma mark - 定时更新本地数据和服务器数据
// 同步手环数据到手机
- (void)runloopBleToMobile {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.bleTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(60.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.bleTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.bleTimer, ^{
        NSLog(@"-----> 定时器同步手环数据到手环数据库表");
        [[VHSStepAlgorithm shareAlgorithm] asynDataFromBraceletToMobileDB:nil];
    });
    dispatch_resume(self.bleTimer);
}
// 同步手机数据到云端
- (void)runloopLocalMobileToNetwork {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.mobileTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(15 * 60 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.mobileTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.mobileTimer, ^{
         NSLog(@"-----> 定时器同步mobile数据到网络服务器数据库表");
        [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:nil];
        [k_NotificationCenter postNotificationName:k_NOTI_SYNCSTEPS_TO_NET object:self];
    });
    // 5. 启动定时器
    dispatch_resume(self.mobileTimer);
}

#pragma mark - 手环相关

-(void)initConnectPeripheralSuccess:(void (^)())success {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SharePeripheral sharePeripheral].bleMolue = [[ASDKBleModule alloc] init];
        [SharePeripheral sharePeripheral].bleMolue.delegate = self;
        [[SharePeripheral sharePeripheral] setCallBackJump:^(CBPeripheral *peripheral){
            NSLog(@"连接成功======");
            if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {
                //绑定且连接状态
                NSLog(@"手环链接－－－并且已经绑定");
                // 证明 - 已经绑定过手环
                NSString *mac = [k_UserDefaults objectForKey:k_SHOUHUAN_MAC_ADDRESS];
                [ShareDataSdk shareInstance].smart_device_id = mac;
                [k_NotificationCenter postNotificationName:DeviceDidConnectedBLEsNotification object:nil userInfo:@{DeviceDidConnectedBLEsUserInfoPeripheral : peripheral}];
            } else {
                NSLog(@"手环链接－－－未绑定  macid====%@",[ShareDataSdk shareInstance].smart_device_id);
                //扫描页面绑定设备
                [k_NotificationCenter postNotificationName:DeviceDidConnectedBLEsNotification object:nil userInfo:@{DeviceDidConnectedBLEsUserInfoPeripheral : peripheral}];
            }
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([SharePeripheral sharePeripheral].bleMolue && success) {
            [self.peripherals removeAllObjects];
            success();
        }
    });
}

#pragma mark - AsdkBleModuleDelegate

// 扫描到外围手环设备回调
- (void)ASDKBLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    PeripheralModel *model = [[PeripheralModel alloc] init];
    if (ABS([RSSI integerValue]) < 80 && [[advertisementData objectForKey:@"kCBAdvDataLocalName"] length]>0) {
        for (PeripheralModel *pm in self.peripherals) {
            if ([pm.UUID isEqualToString:peripheral.identifier.UUIDString]) {
                return;
            }
        }
        model.UUID = peripheral.identifier.UUIDString;
        model.RSSI = ABS([RSSI integerValue]);
        model.name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        [self.peripherals addObject:model];
        // 根据RSSI重新排序
        NSArray *resultArray= [self.peripherals sortedArrayUsingComparator:^NSComparisonResult(PeripheralModel *obj1, PeripheralModel *obj2) {
            NSString *num1=[NSString stringWithFormat:@"%ld",(long)obj1.RSSI];
            NSString *num2=[NSString stringWithFormat:@"%ld",(long)obj2.RSSI];
            [num1 integerValue]<10 ? num1=[NSString stringWithFormat:@"0%@",num1] : nil;
            [num2 integerValue]<10 ? num2=[NSString stringWithFormat:@"0%@",num2] : nil;
            NSComparisonResult result = [num1 compare:num2];
            return result;
        }];
        self.peripherals = [resultArray mutableCopy];
        //发送通知 ，VHSScanFitBraceletController页面刷新设备列表
        [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDidScanBLEsNotification object:nil userInfo:@{DeviceDidScanBLEsUserInfoKey: self.peripherals}];
    }
}

// 连接外围手环设备回调
- (void)ASDKBLEManagerConnectWithState:(BOOL)success andCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (success) {
        [[SharePeripheral sharePeripheral] DiscoerService];
        // 本地保存手环连接时间
        [VHSCommon setShouHuanConnectedTime:[VHSCommon getYmdFromDate:[NSDate date]]];
    } else {
        NSLog(@"连接失败：%@",error);
    }
}

// 断开外围手环设备回调
- (void)ASDKBLEManagerDisConnectWithCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"xl断开连接：%@",error);
}

// 判断蓝牙是否开启
- (void)callBackBleManagerState:(CBCentralManagerState)powerState {
    // 开启蓝牙
    if (CBCentralManagerStatePoweredOn == powerState) {
        [VHSStepAlgorithm shareAlgorithm].CBState = CBManagerStatePoweredOn;
    }
    // 蓝牙关闭
    else if (CBCentralManagerStatePoweredOff == powerState) {
        [VHSStepAlgorithm shareAlgorithm].CBState = CBManagerStatePoweredOff;
    }
}

//此方法是已经绑定手环，下次进入会调用此方法
- (void)callBackReconect:(NSString *)uuidString{
    //加上这2句代码，防止多次连接设备   note by xulong
    CBPeripheral *peri = [ShareDataSdk shareInstance].peripheral;
    if (peri && peri.state == CBPeripheralStateConnecting) {
        return;
    }
    NSString *uuid = [k_UserDefaults objectForKey:k_SHOUHUAN_UUID];
    NSString *name = [k_UserDefaults objectForKey:k_SHOUHUAN_NAME];
    [[SharePeripheral sharePeripheral].bleMolue ASDKSendConnectDevice:uuid];
    [SharePeripheral sharePeripheral].bleName = name;
    
}

- (void)syncFitBleData:(void (^)(int errorCode))syncBlock {
    // 设备未连接
    if ([ShareDataSdk shareInstance].peripheral.state != CBPeripheralStateConnected) {
        if (syncBlock) syncBlock(100);
        return;
    }
    
    ASDKGetHandringData *ASDKHandler = [[ASDKGetHandringData alloc] init];
    [ASDKHandler ASDKSendRequestSportDataForTodayWithUpdateBlock:^(id object, int errorCode) {
        // 同步成功
        if (errorCode == SUCCESS) {
            // 插入一条数据到当前数据库中
        }
        if (syncBlock) {
            syncBlock(errorCode);
        }
    }];
}

#pragma mark - AppPay
/*
 支付结果回调
 照微信SDK Sample，在类实现onResp函数，支付完成后，微信APP会返回到商户APP并回调onResp函数，开发者需要在该函数中接收通知，判断返回错误码，如果支付成功则去后台查询支付结果再展示用户实际支付结果。注意	一定不能以客户端返回作为用户支付的结果，应以服务器端的接收的支付通知或查询API返回的结果为准。
 */
-(void) onResp:(BaseResp*)resp
{
    
    ///NSLog(@"Pay onResp = %@ ",resp);
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp* payResp = (PayResp*)resp;
        
        ///NSLog(@"Pay Response = %@",payResp);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayNotification" object:self userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",payResp.errCode] forKey:@"status"]];
    }
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:NSLocalizedString(@"weixin_req_title01", nil)];
        NSString *strMsg = NSLocalizedString(@"weixin_req_content01", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:NSLocalizedString(@"weixin_req_title02", nil)];
        NSString *strMsg = [NSString stringWithFormat:NSLocalizedString(@"weixin_req_content02", nil), msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:NSLocalizedString(@"weixin_start_title", nil)];
        NSString *strMsg = NSLocalizedString(@"weixin_start_content", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/*
 处理支付宝或分享结果
 */

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([ALIPAY_APP_SCHEME isEqualToString:url.scheme]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [k_NotificationCenter postNotificationName:k_NOTI_ALIPAY_CALLBACK_INFO
                                                object:self
                                              userInfo:resultDic];
        }];
        return YES;
    }
    
    BOOL ret = [WXApi handleOpenURL:url delegate:self];
    if (ret==YES)
        return ret;
    
    return YES;
}

// iOS9 之后出现app之间进行跳转到api
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0){
    
    if ([ALIPAY_APP_SCHEME isEqualToString:url.scheme]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [k_NotificationCenter postNotificationName:k_NOTI_ALIPAY_CALLBACK_INFO
                                                object:self
                                              userInfo:resultDic];
        }];
        return YES;
    }
    
    BOOL ret = [WXApi handleOpenURL:url delegate:self];
    if (ret == YES)
        return ret;
    
    return YES;
}

#pragma mark - 远程通知

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"run+++++++++didReceiveRemoteNotification");
    
    if (completionHandler) {
        NSLog(@"apns-UIBackgroundFetchResultNewData");
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"acitve = %@", userInfo);
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication) {
        NSLog(@"applacation is unactive ===== %@",userInfo);
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"background is Activated Application - %@", userInfo);
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"test-deviceToken:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) { return; }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"] intValue] != 0) { return; }
            // 获取channel_id
            NSString *channelId = [BPush getChannelId];
            NSLog(@"Channel_id == %@",channelId);
            [VHSCommon saveBPushChannelId:[BPush getChannelId]];
            
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"result ============== %@",result);
                }
            }];
            [BPush setTag:@"vhs_gyt_tags" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}


#pragma mark - 通知相关

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // 进入前台，消除所有Badge Number
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    // 一个小时显示启动页
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if (!companyId) {
        // 更新应用进入foreground的时间
        [VHSCommon saveLaunchTime:[VHSCommon getDate:[NSDate date]]];
        return;
    }
    
    NSString *adTime = [k_UserDefaults objectForKey:k_Launch_Time];
    if ([VHSCommon intervalSinceNow:adTime] >= k_Late_Duration(1.0)) {
        NSString *luanchUrl = [k_UserDefaults objectForKey:k_LaunchUrl];
        if (!luanchUrl) {
            [self downloadLaunchUrl:^(NSString *url) {
                [self showLaunchPage:url];
            }];
        } else {
            [self showLaunchPage:luanchUrl];
        }
    }
}

- (void)showLaunchPage:(NSString *)url {
    // 展示广告页
    UIViewController *VC = self.window.rootViewController;
    VHSStartController *startVC = (VHSStartController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSStartController"];
    startVC.launchUrl = url;
    [VC presentViewController:startVC
                     animated:NO
                   completion:^{
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [VC dismissViewControllerAnimated:NO completion:nil];
                       });
                   }];
}

- (void)downloadLaunchUrl:(void (^)(NSString *url))success {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = @"/getAppStart.htm";
    message.httpMethod = VHSNetworkGET;
    
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if (![VHSCommon isNullString:companyId]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:companyId forKey:@"companyId"];
        message.params = dic;
    }
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSString *launchUrl = result[@"startUrl"];
            [VHSCommon saveLaunchUrl:launchUrl];
            if (success) success(launchUrl);
        }
    } fail:^(NSError *error) {}];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:10];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // 取消定时器
//    dispatch_cancel(self.bleTimer);
//    dispatch_cancel(self.mobileTimer);
    
    NSLog(@"%@", [ShareDataSdk shareInstance].peripheral);
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        [[ShareDataSdk shareInstance].peripheral removeObserver:self forKeyPath:@"state"];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 监测手环连接状态的变化
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindDisConnected) {
        [[VHSStepAlgorithm shareAlgorithm] shareBLE];
        [self initConnectPeripheralSuccess:^{
            if ([VHSStepAlgorithm shareAlgorithm].CBState == CBManagerStatePoweredOn) {
                [[VHSStepAlgorithm shareAlgorithm] tryReconnectedBracelet];
                // 监测蓝牙状态改变
                [[ShareDataSdk shareInstance].peripheral addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            }
        }];
    } else if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {
        // 同步手环数据
        [[VHSStepAlgorithm shareAlgorithm] asynDataFromBraceletToMobileDB:^{
            [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:nil];
            [k_NotificationCenter postNotificationName:k_NOTI_SYNCSTEPS_TO_NET object:self];
        }];
    }
    // 开启定时器
//    [self runloopLocalMobileToNetwork];
//    [self runloopBleToMobile]
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//内存警告
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    DLog(@"内存警告");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        NSInteger changeValue = [[change objectForKey:@"new"] integerValue];
        if (changeValue == CBPeripheralStateConnected) {
            // 同步手环数据
            [[VHSStepAlgorithm shareAlgorithm] asynDataFromBraceletToMobileDB:^{
                [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:nil];
                [k_NotificationCenter postNotificationName:k_NOTI_SYNCSTEPS_TO_NET object:self];
            }];
        }
        
    }
}

@end
