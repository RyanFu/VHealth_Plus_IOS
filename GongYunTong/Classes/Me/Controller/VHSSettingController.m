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
#import "VHSActionListController.h"

@interface VHSSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *settingTipLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger actionNumber;

@end

@implementation VHSSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = RGBCOLOR(239.0, 239.0, 239.0);
    self.settingTipLabel.text = [NSString stringWithFormat:@"如果你要开启或关闭%@的新消息提醒通知，请在iPhone的“设置”-“通知”功能中，找到应用程序“%@”更改", [VHSCommon appName], [VHSCommon appName]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self; 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.actionNumber = 0;
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
//    if (BUILD_FOR_RELEASE) return;
    
    self.actionNumber++;
    
    if (self.actionNumber > 30) {
        VHSActionListController *actionVC = (VHSActionListController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSActionListController"];
        [self.navigationController pushViewController:actionVC animated:YES];
    }
//    VHSTestController *testController = [[VHSTestController alloc] init];
//    [self.navigationController pushViewController:testController animated:YES];
}


#pragma mark - 登出

- (IBAction)logout:(id)sender {
    NSString *strMessage = [NSString stringWithFormat:@"您确定要退出%@吗?", [VHSCommon appName]];
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
        //已经绑定手环
        strMessage = @"退出后将解绑手环，确定退出吗?";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)logOutAction {
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_NO_NETWORK];
        return;
    }
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        [self doQuit];
    } else {
        // 网络请求绑定 - 告知服务器手环解绑
        VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
        message.params = @{@"handMac" : [VHSCommon getShouHuanMacAddress], @"actionType" : @"0"};
        message.path = URL_DO_HAND_MAC;
        message.httpMethod = VHSNetworkPOST;
        
        [MBProgressHUD showMessage:TOAST_BLE_UNBINDING];
        [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
            if ([result[@"result"] integerValue] != 200) {
                [MBProgressHUD hiddenHUD];
                [VHSToast toast:result[@"info"]];
                return;
            }
            
            if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindDisConnected) {
                [MBProgressHUD hiddenHUD];
                [VHSFitBraceletStateManager bleUnbindSuccess];
                [self doQuit];
                return;
            }
            
            [[VHSBraceletCoodinator sharePeripheral] braceletorGotoUnbindWithCallBack:^(int errorCode) {
                [MBProgressHUD hiddenHUD];
                [VHSFitBraceletStateManager bleUnbindSuccess]; // 解绑成功后本地存储
        
                [self doQuit];
            }];
        } fail:^(NSError *error) {
            [VHSToast toast:TOAST_NETWORK_SUSPEND];
        }];
    }
}

#pragma mark -  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) return;
    
    [self logOutAction];
}

- (void)doQuit {
    // 应用退出
    [MBProgressHUD showMessage:TOAST_LOGIN_OUTING];
    
    // 为了给用户注销的体验 - 3秒后执行dispatch
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
        message.timeout = 10;
        message.path = URL_DO_QUIT;
        message.httpMethod = VHSNetworkPOST;
        [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
            [MBProgressHUD hiddenHUD];
            if ([result[@"result"] integerValue] != 200) {
                [VHSToast toast:result[@"info"]];
            }
            // 用户信息清除
            [VHSCommon removeLocationUserInfo];
            // 清除用户信息
            [[VHSCommon share] setUserInfo:nil];
            
            // 注销回到登录页面
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UIViewController *vc = [storyboard instantiateInitialViewController];
            UIWindow *wind = [UIApplication sharedApplication].delegate.window;
            wind.rootViewController = vc;
            
        } fail:^(NSError *error) {
            [VHSToast toast:TOAST_NETWORK_SUSPEND];
        }];
    });
}

- (void)dealloc {
    CLog(@"%@ be dealloc", NSStringFromClass([self class]));
}

@end
