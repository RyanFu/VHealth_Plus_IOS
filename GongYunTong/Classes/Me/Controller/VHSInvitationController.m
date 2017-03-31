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
#import "NSString+extension.h"
#import "UILabel+extension.h"

@interface VHSInvitationController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputMobileField;

@property (nonatomic, strong) NSMutableDictionary *invitationInfoDict;

@end

static NSString * const Const_Invitation_Explanation = @"邀请须知：\n*邀请开通功能用于企业用户邀请非平台用户进行体验试用，邀请行为将被记录；\n*被邀请者成功开通账号后，可正常使用平台功能，但因体验平台所产生的健康豆（积分转化而来）不可用作商城商品兑换；\n*被邀请人的登陆账号和密码以开通时填写的被邀请者手机号和下发短信中的唯一密码为准，如无法登陆，请拨打客服电话：400-620-1800；";

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
    self.title = VC_TITLE_INVITATION;
    self.view.backgroundColor = COLORHex(@"#EFEFF4");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(falldownKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT, SCREENW, SCREENH - NAVIAGTION_HEIGHT)];
    scrollView.backgroundColor = COLORHex(@"#EFEFF4");
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    CGFloat spaceBreak = 28;
    
    self.inputMobileField = [[UITextField alloc] initWithFrame:CGRectMake(15, spaceBreak, SCREENW - 30, 45)];
    self.inputMobileField.placeholder = @"请输入要开通的手机号码";
    self.inputMobileField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputMobileField.delegate = self;
    [scrollView addSubview:self.inputMobileField];
    
    UIButton *openAccountBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.inputMobileField.frame.origin.x, CGRectGetMaxY(self.inputMobileField.frame) + spaceBreak, self.inputMobileField.frame.size.width, 44)];
    openAccountBtn.backgroundColor = COLORHex(@"#e65248");
    [openAccountBtn setTitle:@"开通账号" forState:UIControlStateNormal];
    [openAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openAccountBtn addTarget:self action:@selector(openAccountClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:openAccountBtn];
    
    openAccountBtn.layer.cornerRadius = 5;
    openAccountBtn.layer.masksToBounds = YES;
    
    UILabel *explanationLabel = [[UILabel alloc] init];
    explanationLabel.font = [UIFont systemFontOfSize:15];
    explanationLabel.textColor = COLORHex(@"#666666");
    explanationLabel.text = Const_Invitation_Explanation;
    explanationLabel.numberOfLines = 0;
    explanationLabel.frame = CGRectMake(15, CGRectGetMaxY(openAccountBtn.frame) + 35, openAccountBtn.frame.size.width, 100);
    [explanationLabel lineSpacingWithSpace:1.5];
    
    CGFloat explanationHeight = [Const_Invitation_Explanation computerWithSize:CGSizeMake(explanationLabel.frame.size.width, CGFLOAT_MAX) font:explanationLabel.font].height;
    explanationLabel.frame = CGRectMake(15, CGRectGetMaxY(openAccountBtn.frame) + 40, openAccountBtn.frame.size.width, explanationHeight + 20);
    [scrollView addSubview:explanationLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 手势操作

- (void)openAccountClick:(UIButton *)btn {
    [self.view endEditing:YES];
    
    NSString *mobile = self.inputMobileField.text;
    if ([VHSCommon isNullString:mobile]) {
        [VHSToast toast:TOAST_NEED_INPUT_MOBILE];
        return;
    }
    [self.invitationInfoDict setObject:mobile forKeyedSubscript:@"mobile"];
    
    [VHSAccountNiceView share].invitationInfoDict = self.invitationInfoDict;
    [[VHSAccountNiceView share] alertWithTitle:@"提示" prompt:@"确定开通后，被邀请者可通过该手机号和稍后下发的短信密码登陆平台。确定开通该手机号码为平台体验用户吗?" actions:@[@"确定", @"取消"]];

}

- (void)falldownKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)dealloc {
    CLog(@"%@ be dealloc", NSStringFromClass([self class]));
}
@end
