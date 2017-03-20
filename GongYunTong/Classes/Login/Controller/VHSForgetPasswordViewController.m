//
//  VHSForgetPasswordViewController.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSForgetPasswordViewController.h"
#import "VHSPasswordCell.h"
#import "VHSPhoneNumberCell.h"
#import "VHSForgetInfo.h"
#import "MBProgressHUD+VHS.h"
#import "VHSTabBarController.h"

@interface VHSForgetPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView  * tvPassWord;
@property (nonatomic, strong) NSArray               * array;
@property (nonatomic, strong) NSMutableDictionary   * passwordInfoDict;     // 新密码信息

@property (nonatomic, strong) UITextField *phoneTextField;
@end

@implementation VHSForgetPasswordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    footerView.backgroundColor = COLORHex(@"#EFEFF4");
    _tvPassWord.tableFooterView = footerView;
    
    UIButton *butConfirm = [[UIButton alloc] init];
    butConfirm.layer.cornerRadius = 10;
    butConfirm.layer.masksToBounds = YES;
    butConfirm.frame = CGRectMake(0, 0, 280, 50);
    butConfirm.center = CGPointMake(SCREEN_WIDTH/2, 55);
    butConfirm.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0f];
    [butConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [butConfirm addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:butConfirm];
    
    UILabel *labphone = [[UILabel alloc] init];
    labphone.frame = CGRectMake(0, 0, 200, 20);
    labphone.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 84);
    labphone.text = @"联系客服 400-620-1800";
    labphone.font = [UIFont systemFontOfSize:14];
    labphone.textAlignment = NSTextAlignmentCenter;
    labphone.textColor = [UIColor colorWithHexString:@"#1e5bf2"];
    [_tvPassWord addSubview:labphone];
    
    self.tvPassWord.backgroundColor = COLORHex(@"#EFEFF4");
    self.tvPassWord.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downKyboard)];
    [self.tvPassWord addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 设置导航栏的背景色不透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    // 设置导航栏title颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSMutableDictionary *)passwordInfoDict {
    if (!_passwordInfoDict) {
        _passwordInfoDict = [NSMutableDictionary new];
    }
    return _passwordInfoDict;
}

- (NSArray *)array {
    if (!_array) {
        VHSForgetInfo *phone = [VHSForgetInfo infoWithTitle:@"手机号" placeholder:@"手机号"];
        VHSForgetInfo *yanzheng = [VHSForgetInfo infoWithTitle:@"验证码" placeholder:@"请输入验证码"];
        VHSForgetInfo *password = [VHSForgetInfo infoWithTitle:@"密码" placeholder:@"请输入密码"];
        _array = @[phone,yanzheng,password];
    }
    return _array;
}
-(void)downKyboard {
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"PhoneNumberCell";
            VHSPhoneNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.callBack = ^(NSString *phoneNumber) {
                [self.passwordInfoDict setObject:phoneNumber forKey:@"mobile"];
            };
            return cell;
        }
        else if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"PasswordCell";
            VHSPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.callBack = ^(NSString *vCode) {
                [self.passwordInfoDict setObject:vCode forKey:@"verCode"];
            };
            return cell;
        }

    } else {

        static NSString *CellIdentifier = @"PasswordCell";
        VHSPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.model = self.array.lastObject;
        cell.callBack = ^(NSString *newPassWord) {
            CLog(@"newPassword = %@", newPassWord);
            [self.passwordInfoDict setObject:newPassWord forKey:@"newPassword"];
        };
        return cell;
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"通过手机号找回密码";
    }
    if (section == 1) {
        return @"创建新密码";
    }
    return NULL;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 35.0;
    }
    return 0.0;
}

#pragma mark - 修改信息提交
- (void)confirmBtnClick:(UIButton *)sender {
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_UP_PASSWORD_CODE;
    message.params = self.passwordInfoDict;
    message.httpMethod = VHSNetworkPOST;
    
    [MBProgressHUD showMessage:nil];
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        if ([result[@"result"] integerValue] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [VHSToast toast:result[@"info"]];
    } fail:^(NSError *error) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
    
}

@end
