//
//  VHSInvitationController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/28.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSInvitationController.h"
#import "UIButton+extension.h"
#import "VHSAccountNiceView.h"

@interface VHSInvitationController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputMobileField;
@property (nonatomic, strong) UITextField *inputVercodeField;
@property (nonatomic, strong) UIButton *sendVercodeBtn;

@property (nonatomic, strong) NSMutableDictionary *invitationInfoDict;

@end

static NSString * const PAGE_TITLE = @"邀请开通";

@implementation VHSInvitationController

#pragma mark - override getter or method

- (NSMutableDictionary *)invitationInfoDict {
    if (!_invitationInfoDict) {
        _invitationInfoDict = [NSMutableDictionary new];
    }
    return _invitationInfoDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = PAGE_TITLE;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(falldownKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupUI {
    self.inputMobileField = [[UITextField alloc] initWithFrame:CGRectMake(15, NAVIAGTION_HEIGHT + 20, SCREENW - 30, 45)];
    self.inputMobileField.placeholder = @"请输入要开通的手机号码";
    self.inputMobileField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputMobileField.delegate = self;
    [self.view addSubview:self.inputMobileField];
    
    CGFloat sendBtnWidth = 110;
    
    self.inputVercodeField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.inputMobileField.frame) + 20, SCREENW - 30 - sendBtnWidth, 45)];
    self.inputVercodeField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.inputVercodeField];
    
    self.sendVercodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.inputVercodeField.frame) - 10, CGRectGetMinY(self.inputVercodeField.frame), sendBtnWidth + 10, 45)];
    [self.sendVercodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendVercodeBtn setBackgroundColor:COLORHex(@"#999999")];
    [self.sendVercodeBtn addTarget:self action:@selector(getVercode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendVercodeBtn];
    
    // 创建蒙版
    CGRect maskRect = CGRectMake(0, 0, self.sendVercodeBtn.bounds.size.width, self.sendVercodeBtn.bounds.size.height);
    CGSize maskRadius = CGSizeMake(5, 5);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:maskRect byRoundingCorners:corners cornerRadii:maskRadius];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.sendVercodeBtn.layer.mask = shapeLayer;
    
    CGFloat accountBtnWidth = 224;
    
    UIButton *openAccountBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENW - 224) / 2, CGRectGetMaxY(self.inputVercodeField.frame) + 35, accountBtnWidth, 44)];
    openAccountBtn.backgroundColor = COLORHex(@"#e65248");
    [openAccountBtn setTitle:@"开通账号" forState:UIControlStateNormal];
    [openAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openAccountBtn addTarget:self action:@selector(sendOpenAccountClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openAccountBtn];
    
    openAccountBtn.layer.cornerRadius = 5;
    openAccountBtn.layer.masksToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:PAGE_TITLE];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:PAGE_TITLE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 手势操作

- (void)getVercode:(UIButton *)btn {
    [btn countdownDonotChangeWithSeconds:120];
    
    NSString *mobile = self.inputMobileField.text;
    if ([VHSCommon isNullString:mobile]) {
        [VHSToast toast:TOAST_NEED_INPUT_MOBILE];
        return;
    }
    
    [self.invitationInfoDict setObject:mobile forKey:@"mobile"];
    
    [self getServerVercode];
}

- (void)getServerVercode {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = @"";
    message.httpMethod = VHSNetworkPOST;
    message.params = self.invitationInfoDict;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)sendOpenAccountClick:(UIButton *)btn {
    [self.view endEditing:YES];
    
    NSString *mobile = self.inputMobileField.text;
    if ([VHSCommon isNullString:mobile]) {
        [VHSToast toast:TOAST_NEED_INPUT_MOBILE];
        return;
    }
    NSString *vercode = self.inputVercodeField.text;
    if ([VHSCommon isNullString:vercode]) {
        [VHSToast toast:TOAST_NEED_INPUT_VERCODE];
        return;
    }
    [self.invitationInfoDict setObject:vercode forKey:@"vercode"];
    
    [VHSAccountNiceView showWithMainContent:@"请使用已开通的手机号登陆，初始密码为: 666666"];
    
    [self serverOpenAccount];
}

- (void)serverOpenAccount {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = @"";
    message.httpMethod = VHSNetworkPOST;
    message.params = self.invitationInfoDict;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        
    } fail:^(NSError *error) {
        
    }];
}


- (void)falldownKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}


@end
