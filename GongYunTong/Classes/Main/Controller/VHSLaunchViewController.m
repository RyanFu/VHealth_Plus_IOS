//
//  VHSLaunchViewController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 lucky. All rights reserved.
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
    
    // 加载广告页
    [self downloadADPage];
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
        
        if ([result[@"result"] integerValue] != 200) {
            [self setupRootController];
            return;
        }
        
        self.startUrl = result[@"startUrl"];
        self.startTime = [result[@"startTime"] integerValue];
        [self setupLanuchWithUrl:self.startUrl duration:self.startTime];
        
    } fail:^(NSError *error) {
        [self setupRootController];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupLanuchWithUrl:(NSString *)startUrl duration:(NSInteger)durationTime {
    
    if ([VHSCommon isNullString:startUrl]) {
        [self setupRootController];
        return;
    }
    
    [self showADPageWithUrl:startUrl duration:durationTime];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupRootController];
    });
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

- (void)showADPageWithUrl:(NSString *)url duration:(NSInteger)duration {
    VHSStartController *startController = (VHSStartController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSStartController"];
    startController.launchUrl = url;
    startController.durationTime = duration;
    [self presentViewController:startController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
