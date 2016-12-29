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

@interface VHSLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (strong, nonatomic) IBOutlet UITextField *txtAccount;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@end

#define top_space_ratio         95.0 / 667.0

@implementation VHSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topSpace.constant = top_space_ratio * SCREENH;
    
    // username
    NSString *username = [VHSCommon getUserDefautForKey:k_User_Name];;
    // 默认密码和账户
    self.txtAccount.text = username;
//    self.txtPassword.text = @"123456";
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
    message.params = @{@"loginName" : account,
                       @"password" : password,
                       @"appversion" : [VHSCommon appVersion],
                       @"osversion" : [VHSCommon osNameVersion],
                       @"channelId" : [VHSCommon getChannelId]};
    message.path = URL_LOGIN;
    message.httpMethod = VHSNetworkPOST;
    
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
        NSString *macAddress = result[@"handMac"];
        if (![VHSCommon isNullString:macAddress]) {
            [VHSCommon saveUserDefault:macAddress forKey:k_SHOUHUAN_MAC_ADDRESS];
        }
        
        // 保存用户信息到本地
        [self persistentUserInfo:result];
        
        // 判断登录次数
        if (loginModel.loginNum == 0) {
            // 第0次登录的时候跳到注册页面
            VHSLoginPersonalViewController *VC = (VHSLoginPersonalViewController *)[StoryboardHelper controllerWithStoryboardName:@"Login" controllerId:@"VHSLoginPersonalViewController"];
            VC.model = loginModel;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            // 其他时候登录跳转到主页面
            VHSTabBarController *tabBarVC = (VHSTabBarController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
            [self.navigationController pushViewController:tabBarVC animated:YES];
        }
        
        [self transferStepData];
    } fail:^(NSError *error) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

// 保存用户信息到本地
- (void)persistentUserInfo:(NSDictionary *)userDict {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"gender"] integerValue]] forKey:@"gender"];
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"height"] integerValue]] forKey:@"height"];
    [userInfo setObject:[NSNumber numberWithDouble:[userDict[@"weight"] doubleValue]] forKey:@"weight"];
    [userInfo setObject:[NSString stringWithFormat:@"%@", userDict[@"birthday"]] forKey:@"birthday"];
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"upgrade"] integerValue]] forKey:@"upgrade"];
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"acceptMsg"] integerValue]] forKey:@"acceptMsg"];
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"addStepMaxNum"] integerValue]] forKeyedSubscript:@"addStepMaxNum"];
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"memberId"] integerValue]] forKey:@"memberId"];
    [userInfo setObject:[NSString stringWithFormat:@"%@", [VHSUtils absolutelyString:_txtAccount.text]] forKey:@"account"];
    [userInfo setObject:[NSNumber numberWithInteger:[userDict[@"companyId"] integerValue]] forKey:@"companyId"];
    
    [VHSCommon saveUserDefault:userInfo forKey:@"userInfo"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"登录"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"登录"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 服务器数据迁移至本地
/// 迁移服务器步数到本地数据表
- (void)transferStepData {
    [self getMemberStep];
}

/// 获取服务器步数
- (void)getMemberStep {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_MEMBER_STEP;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        NSMutableArray *netstepList = [NSMutableArray new];
        if ([result[@"sportList"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"sportList"]) {
                TransferStepModel *step = [TransferStepModel yy_modelWithDictionary:dict];
                [netstepList addObject:step];
            }
        }
        //  服务器端无数据，不需要迁移
        if (![netstepList count]) return;
        
        for (TransferStepModel *net in netstepList) {
            // 更新数据到本地
            VHSActionData *ac = [[VHSActionData alloc] init];
            ac.actionId = [VHSCommon getTimeStamp];
            ac.macAddress = net.handMac;
            ac.memberId = net.memberId;
            ac.step = [NSString stringWithFormat:@"%ld", net.step];
            ac.actionType = [net.handMac isEqualToString:@"0"] ? @"2" : @"1";
            ac.recordTime = net.sportDate;
            ac.upload = 1;
            ac.distance = net.km;
            [[VHSStepAlgorithm shareAlgorithm] updateSportStep:ac];
        }
    } fail:^(NSError *error) {}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
