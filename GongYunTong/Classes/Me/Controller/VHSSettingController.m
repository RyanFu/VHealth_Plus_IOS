//
//  VHSSettingController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSSettingController.h"
#import "VHSSettingCell.h"
#import "VHSTestController.h"
#import "VHSFitBraceletStateManager.h"
#import "MBProgressHUD+VHS.h"

@interface VHSSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VHSSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = RGBCOLOR(239.0, 239.0, 239.0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self; 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate, Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VHSSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSSettingCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (VHEALTH_BUILD_FOR_RELEASE) return;
    
    VHSTestController *testController = [[VHSTestController alloc] init];
    [self.navigationController pushViewController:testController animated:YES];
}


#pragma mark - 登出

- (IBAction)logout:(id)sender {
    NSString *strMessage = @"您确定要退出V健康+吗?";
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
        //已经绑定手环
        strMessage = @"退出后将解绑手环，确定退出吗?";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

#pragma mark -  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // edited by linpingjun - 2016.8.22
        void(^logOut)()=^{
            
            [MBProgressHUD showMessage:@"注销中..."];
            if (![VHSCommon isNetworkAvailable]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hiddenHUD];
                    [VHSToast toast:TOAST_NETWORK_SUSPEND];
                });
                return;
            }
            
            [self doQuitSuccess:^(BOOL isSuccess) {
                [MBProgressHUD hiddenHUD];
                if (isSuccess) {
                    // 用户信息清除
                    [VHSCommon removeLocationUserInfo];
                
                    // 注销回到登录页面
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    UIViewController *vc = [storyboard instantiateInitialViewController];
                    UIWindow *wind = [UIApplication sharedApplication].delegate.window;
                    wind.rootViewController = vc;
                } else {
                    [VHSToast toast:TOAST_NETWORK_SUSPEND];
                }
            }];
        };
        
        if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
            // 已绑定手环  解绑手环
            [self unBindingBLE:^(BOOL isSuccess) {
                if (isSuccess) {
                    logOut();
                }
            }];
        } else {
            logOut();
        }
    }
}

- (void)unBindingBLE:(void (^)(BOOL isSuccess))unbindSuccessBlock {
    
    if (![VHSCommon isNetworkAvailable]) {
        if (unbindSuccessBlock) unbindSuccessBlock(NO);
        [VHSToast toast:TOAST_NO_NETWORK];
        return;
    }
    
    // 网络请求绑定 - 告知服务器手环解绑
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.params = @{@"handMac" : [VHSCommon getUserDefautForKey:k_SHOUHUAN_MAC_ADDRESS],
                       @"actionType" : @"0"};
    message.path = URL_DO_HAND_MAC;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *resultObject) {
        if ([resultObject[@"result"] integerValue] == 200) {
            if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {
                //连接状态下解绑
                [MBProgressHUD showMessage:@"正在解绑..."];
                ASDKSetting *ASDK = [[ASDKSetting alloc] init];
                [ASDK ASDKSendDeviceBindingWithCMDType:ASDKDeviceUnbundling withUpdateBlock:^(int errorCode) {
                    [MBProgressHUD hiddenHUD];
                    if (errorCode == SUCCESS) {
                        [VHSToast toast:TOAST_BLE_UNBIND_SUCCESS];
                        [VHSFitBraceletStateManager BLEUnbindSuccess]; // 解绑成功后本地存储
                        if (unbindSuccessBlock) unbindSuccessBlock(YES);
                    } else {
                        if (unbindSuccessBlock) unbindSuccessBlock(NO);
                        [VHSToast toast:TOAST_BLE_UNBIND_FAIL];
                    }
                }];
            }
            else if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindDisConnected) {
                [VHSToast toast:TOAST_BLE_UNBIND_SUCCESS];
                [VHSFitBraceletStateManager BLEUnbindSuccess]; // 解绑成功后本地存储
                if (unbindSuccessBlock) unbindSuccessBlock(NO);
            }
            else {
                if (unbindSuccessBlock) unbindSuccessBlock(NO);
            }
        } else {
            if (unbindSuccessBlock) unbindSuccessBlock(NO);
            [VHSToast toast:resultObject[@"info"]];
        }
    } fail:^(NSError *error) {
        if (unbindSuccessBlock) unbindSuccessBlock(NO);
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

- (void)doQuitSuccess:(void (^)(BOOL isSuccess))successBlock {
    // 应用退出
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.timeout = 10;
    message.path = URL_DO_QUIT;
    message.httpMethod = VHSNetworkPOST;
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            if (successBlock) successBlock(YES);
        } else {
            if (successBlock) successBlock(NO);
        }
    } fail:^(NSError *error) {
        if (successBlock) successBlock(NO);
    }];
}

@end
