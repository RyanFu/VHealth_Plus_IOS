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
#import "VHSAdvertisingController.h"

@interface VHSLaunchViewController ()

@end

@implementation VHSLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载广告页
    [self showAdvertisingPage];
}

/// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showAdvertisingPage {
    // 无网络
    if (![VHSCommon isNetworkAvailable]) {
        [VHSCommon setupRootController];
        return;
    }
    
    // 根据公司ID返回广告页
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if ([VHSCommon isNullString:companyId]) {
        [VHSCommon setupRootController];
        return;
    }
    
    NSString *adUrl = [VHSCommon getUserDefautForKey:k_LaunchUrl];
    NSUInteger duration = [[VHSCommon getUserDefautForKey:K_Launch_Duration] integerValue];
    
    if (![VHSCommon isNullString:adUrl] && duration > 0) {
        VHSAdvertisingController *adVC = [[VHSAdvertisingController alloc] initWithAdUrl:adUrl duration:duration dismissCallBack:^{
            [self setupRootController];
        }];
        [self.navigationController pushViewController:adVC animated:NO];
        
    } else {
        [self setupRootController];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupRootController {
    [VHSCommon setupRootController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
