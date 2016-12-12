//
//  VHSLaunchViewController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSLaunchViewController.h"
#import "VHSStartController.h"
#import "VHSTabBarController.h"
#import "MBProgressHUD+VHS.h"

@interface VHSLaunchViewController ()

@property (nonatomic, strong) NSString *startUrl;
@property (nonatomic, assign) NSInteger startTime;

@end

@implementation VHSLaunchViewController

- (void)setStartUrl:(NSString *)startUrl {
    if (_startUrl != startUrl) {
        _startUrl = startUrl;
        // 本地化保存启动连接
        [VHSCommon saveLaunchUrl:_startUrl];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self freeLogin];
    [self downloadStartImage];
}

- (void)downloadStartImage {
    
    if (![VHSCommon isNetworkAvailable]) {
        [self setupLanuchWithUrl:nil duration:0];
        return;
    }
    // 获取app启动页
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_APP_START;
    message.httpMethod = VHSNetworkGET;
    message.timeout = 2.0;
    
    // 根据公司ID返回广告页
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if (![VHSCommon isNullString:companyId]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:companyId forKey:@"companyId"];
        message.params = dic;
        
        [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
            if ([result[@"result"] integerValue] == 200) {
                self.startUrl = result[@"startUrl"];
                self.startTime = [result[@"startTime"] integerValue];
                
                [self setupLanuchWithUrl:self.startUrl duration:self.startTime];
            } else {
                [self setupLanuchWithUrl:nil duration:0];
            }
        } fail:^(NSError *error) {
            [self setupLanuchWithUrl:nil duration:0];
        }];
    } else {
        [self setupLanuchWithUrl:nil duration:0.0];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupLanuchWithUrl:(NSString *)startUrl duration:(NSInteger)durationTime {

    if (![VHSCommon isNullString:startUrl]) {
        VHSStartController *startController = (VHSStartController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSStartController"];
        startController.launchUrl = startUrl;
        startController.durationTime = durationTime;
        UIWindow *wind = [UIApplication sharedApplication].delegate.window;
        wind.rootViewController = startController;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([VHSCommon isLogined]) {
                // 已经登录过时候登录跳转到主页面
                VHSTabBarController *tabBarVC = (VHSTabBarController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
                [self.navigationController pushViewController:tabBarVC animated:YES];
                UIWindow *wind = [UIApplication sharedApplication].delegate.window;
                wind.rootViewController = tabBarVC;
            } else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                UIViewController *vc = [storyboard instantiateInitialViewController];
                UIWindow *wind = [UIApplication sharedApplication].delegate.window;
                wind.rootViewController = vc;
            }
        });
    } else {
        if ([VHSCommon isLogined]) {
            // 已经登录过时候登录跳转到主页面
            VHSTabBarController *tabBarVC = (VHSTabBarController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
            [self.navigationController pushViewController:tabBarVC animated:false];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UIViewController *vc = [storyboard instantiateInitialViewController];
            UIWindow *wind = [UIApplication sharedApplication].delegate.window;
            wind.rootViewController = vc;
        }
    }
}

- (void)freeLogin {
    // 登陆成功后－本地化vhstoken
    [k_UserDefaults setObject:@"890lkjAOIFWOEHTQHET" forKey:k_VHS_Token];
    [k_UserDefaults setObject:@"0.35" forKey:k_Steps_To_Kilometre_Ratio];
    [k_UserDefaults setObject:@"13661593213" forKey:k_User_Name];
    [k_UserDefaults synchronize];
    
    // 已经登录过时候登录跳转到主页面
    VHSTabBarController *tabBarVC = (VHSTabBarController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
    [self.navigationController pushViewController:tabBarVC animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
