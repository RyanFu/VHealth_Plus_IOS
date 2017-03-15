//
//  VHSLaunchViewController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSLaunchViewController.h"
#import "VHSTabBarController.h"
#import "MBProgressHUD+VHS.h"

@interface VHSLaunchViewController ()

@end

@implementation VHSLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载广告页
    [self downloadADPage];
}

/// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)downloadADPage {
    
    // 无网络
    if (![VHSCommon isNetworkAvailable]) {
        [self setupRootController];
        return;
    }
    
    // 根据公司ID返回广告页
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if ([VHSCommon isNullString:companyId]) {
        [self setupRootController];
        return;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_APP_START;
    message.httpMethod = VHSNetworkGET;
    message.timeout = 2.0;
    message.params = @{@"companyId" : companyId};
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        
        NSString *startUrl = result[@"startUrl"];
        NSInteger duration = [result[@"startTime"] integerValue];
        // 保存广告页的地址
        [VHSCommon saveLaunchUrl:startUrl];
        
        [self setupLanuchWithUrl:startUrl duration:duration];
        
        [self performSelector:@selector(setupRootController) withObject:nil afterDelay:duration - 0.2];

    } fail:^(NSError *error) {
        [self setupRootController];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupLanuchWithUrl:(NSString *)startUrl duration:(NSInteger)durationTime {
    
    if ([VHSCommon isNullString:startUrl]) return;
    
    [VHSCommon showADPageWithUrl:startUrl duration:durationTime];
}

/// 设置项目的根视图
- (void)setupRootController {
    [VHSCommon isLogined] ? [self rootOfTabbarController] : [self rootOfLoginController];
}

- (void)rootOfTabbarController {
    VHSTabBarController *tabBarVC = (VHSTabBarController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
    [self.navigationController pushViewController:tabBarVC animated:NO];
}

- (void)rootOfLoginController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    UIWindow *wind = [UIApplication sharedApplication].delegate.window;
    wind.rootViewController = vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
