//
//  VHSLoginController.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSLoginController.h"
#import "VHSLoginPersonalViewController.h"
#import "LoginModel.h"
#import "MBProgressHUD+VHS.h"
#import "NSDate+VHSExtension.h"
#import "VHSStepAlgorithm.h"
#import "VHSFitBraceletStateManager.h"
#import "VHSActionData.h"
#import "TransferStepModel.h"
#import "VHSTabBarController.h"
#import "VHSSecurityUtil.h"
#import "ThirdPartyCoordinator.h"

@interface VHSLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (strong, nonatomic) IBOutlet UITextField *txtAccount;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *loginIconImageView;

@end

#define top_space_ratio         95.0 / 667.0

@implementation VHSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topSpace.constant = top_space_ratio * SCREENH;
    self.title = @"登录";
    // username
    NSString *username = [VHSCommon getUserDefautForKey:k_User_Name];;
    // 默认密码和账户
    self.txtAccount.text = username;
//    self.txtPassword.text = @"123456";
    
    // 根据info.plist中的appName判断登陆icon
    if ([[VHSCommon appName] isEqualToString:@"悦动申能"]) {
        self.loginIconImageView.image = [UIImage imageNamed:@"ydsn_login_icon"];
    } else if ([[VHSCommon appName] isEqualToString:@"V健康+"]) {
        self.loginIconImageView.image = [UIImage imageNamed:@"gongyuntong_login_icon"];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_txtAccount]) {
        [_txtPassword becomeFirstResponder];
    }
    else if ([textField isEqual:_txtPassword]){
        [_txtPassword resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (iPhone4 && [textField isEqual:_txtPassword]) {
        // 输入时画面上移
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.30];
        [self.view layoutIfNeeded];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   if (iPhone4 && [textField isEqual:_txtPassword]) {
        // 结束输入时画面还原
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.30];
        [self.view layoutIfNeeded];
        [UIView commitAnimations];
    }
}
- (IBAction)butClickPush:(id)sender {
    
    NSString *account = _txtAccount.text;
    NSString *password = _txtPassword.text;
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_LOGIN;
    message.httpMethod = VHSNetworkPOST;
    message.params = @{@"loginName" : account,
                       @"password" : password,
                       @"appversion" : [VHSCommon appVersion],
                       @"osversion" : [VHSCommon osNameVersion],
                       @"channelId" : [VHSCommon getChannelId]};
    
    // 签名 用于服务器校对数据是否在网络过程中被篡改
    NSString *signStr = [NSString stringWithFormat:@"%@%@", account, [VHSCommon getChannelId]];
    NSString *sign = [VHSUtils md5_base64:signStr];
    message.sign = sign;
    
    [MBProgressHUD showMessage:nil];
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary * result) {
        
        [MBProgressHUD hiddenHUD];
        if ([result[@"result"] integerValue] != 200) {
            [VHSToast toast:result[@"info"]];
            return;
        }
        
        LoginModel *loginModel = [LoginModel yy_modelWithDictionary:result];
        
        // 登陆成功后－本地化vhstoken
        [VHSCommon saveUserDefault:result[@"vhstoken"] forKey:k_VHS_Token];
        [VHSCommon saveUserDefault:[NSNumber numberWithInteger:[result[@"loginNum"] integerValue]] forKey:k_LOGIN_NUMBERS];
        [VHSCommon saveUserDefault:result[@"stride"] forKey:k_Steps_To_Kilometre_Ratio];
        [VHSCommon saveUserDefault:account forKey:k_User_Name];
        [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]] forKey:k_M7_MOBILE_SYNC_TIME];
        
        // 保存用户信息到本地
        [self persistentUserInfo:result];
        
        // 判断登录次数
        if (loginModel.loginNum == 0) {
            // 第0次登录的时候跳到注册页面
            VHSLoginPersonalViewController *VC = (VHSLoginPersonalViewController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Login" controllerId:@"VHSLoginPersonalViewController"];
            VC.model = loginModel;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            // 其他时候登录跳转到主页面
            VHSTabBarController *tabBarVC = (VHSTabBarController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
            [self.navigationController pushViewController:tabBarVC animated:YES];
        }
        
        // 登陆初始化融云SDK
        [[ThirdPartyCoordinator shareCoordinator] setupRCKit];
        // 删除数据库数据
        [self deleteAllActionData];
        // 获取服务端数据
        [self getMemberStep];
        // 开始appVersion
        [VHSCommon saveUserDefault:[VHSCommon appVersion] forKey:k_APPVERSION];
    } fail:^(NSError *error) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

// 保存用户信息到本地
- (void)persistentUserInfo:(NSDictionary *)userDict {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:userDict];
    [userInfo removeObjectForKey:@"result"];
    [userInfo removeObjectForKey:@"info"];
    [userInfo setObject:userDict[@"stride"] forKey:@"stride"];
    [userInfo setObject:userDict[@"vhstoken"] forKey:@"vhstoken"];
    
    [userInfo setObject: [VHSUtils absolutelyString:_txtAccount.text] forKey:@"account"];
    [VHSCommon saveUserDefault:userInfo forKey:@"userInfo"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 服务器数据迁移至本地
/// 获取服务器步数
- (void)getMemberStep {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_MEMBER_STEP;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        NSMutableArray *netstepList = [NSMutableArray new];
        for (NSDictionary *dict in result[@"sportList"]) {
            TransferStepModel *step = [TransferStepModel yy_modelWithDictionary:dict];
            [netstepList addObject:step];
        }
        
        for (TransferStepModel *net in netstepList) {
            // 更新数据到本地
            NSString *handMac = net.handMac;
            if ([handMac containsString:@"null"] || [VHSCommon isNullString:handMac]) {
                continue;
            }
            VHSActionData *action = [[VHSActionData alloc] init];
            action.actionId = [VHSCommon getTimeStamp];
            action.macAddress = [handMac lowercaseString];
            action.memberId = [[VHSCommon userInfo].memberId stringValue];
            action.actionType = [net.handMac isEqualToString:@"0"] ? @"2" : @"1";
            action.recordTime = net.sportDate;
            action.upload = 1;
            action.distance = net.km;
            action.step = [NSString stringWithFormat:@"%@", @(net.step)];
            action.startTime = [VHSCommon getDate:[NSDate date]];
            action.initialStep = @"0";

            action.currentDeviceStep = @"0";
            
            [[VHSStepAlgorithm shareAlgorithm] updateSportStep:action];
        }
        
        // 开始手机计步
        [[VHSStepAlgorithm shareAlgorithm] startMobileStepRecord];
    } fail:^(NSError *error) {}];
}

#pragma mark - 判断登陆时候是否是绑定了手环

- (void)deleteAllActionData {
    // 未绑定
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
        // 删除本地手环绑定标示
        [VHSFitBraceletStateManager bleUnbindSuccess];
        // 绑定手环前先断开手环连接信息
        if ([ShareDataSdk shareInstance].peripheral) {
            [[VHSBraceletCoodinator sharePeripheral] disconnectBraceletorWithPeripheral:[ShareDataSdk shareInstance].peripheral];
        }
    }
    // 删除表中所有的数据
    [[VHSStepAlgorithm shareAlgorithm] deleteAllAction];
}

@end
