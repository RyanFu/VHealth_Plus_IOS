//
//  VHSFeedbackController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSFeedbackController.h"
#import "VHSQuestionPhoneCell.h"
#import "VHSFeedbackCell.h"
#import "MBProgressHUD+VHS.h"
#import "OneAlertCaller.h"

@interface VHSFeedbackController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackPhoneNmber;

@end

@implementation VHSFeedbackController

#pragma mark - override getter method

- (NSMutableDictionary *)feedbackDict {
    if (!_feedbackDict) {
        _feedbackDict = [NSMutableDictionary new];
    }
    return _feedbackDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString *feedbackPhone = [[self.feedbackPhoneNmber.text componentsSeparatedByString:@":"] lastObject];
    
    NSMutableAttributedString *phoneAttributes = [[NSMutableAttributedString alloc] initWithString:self.feedbackPhoneNmber.text];
    NSRange range = NSMakeRange([self.feedbackPhoneNmber.text rangeOfString:feedbackPhone].location, feedbackPhone.length);
    [phoneAttributes addAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(30, 91, 242)} range:range];
    [self.feedbackPhoneNmber setAttributedText:phoneAttributes];
    
    self.feedbackPhoneNmber.userInteractionEnabled = YES;
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCall)];
    [self.feedbackPhoneNmber addGestureRecognizer:phoneTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fallKeyboard)];
    [self.view addGestureRecognizer:tap];
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
}

// 问题反馈提交按钮点击
- (IBAction)submitFeedback:(UIButton *)sender {
    
    [self fallKeyboard];
    
    // 进行校验数据输入的数据是否符合规定
    NSString *suggestion = self.feedbackDict[@"suggestion"];
    if ([suggestion isEqualToString:@""] || suggestion.length == 0 || [suggestion isEqualToString:@"问题描述"]) {
        [VHSToast toast:TOAST_UNFINISH_FEEDBACK_INFO];
        return;
    }
    
    [self postFeedbackSuggestion];
    
    if (self.callBack) {
        self.callBack(self.feedbackDict);
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 0) {
        VHSFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSFeedbackCell"];
        cell.content = [self.feedbackDict objectForKey:@"suggestion"];
        cell.callBack = ^(NSString *feedbackDesc) {
            [weakSelf.feedbackDict setObject:feedbackDesc forKey:@"suggestion"];
        };
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        VHSQuestionPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSQuestionPhoneCell"];
        cell.phoneNumberStr = [self.feedbackDict objectForKey:@"mobile"];
        cell.callBack = ^(NSString *phoneNumber) {
            [weakSelf.feedbackDict setObject:phoneNumber forKey:@"mobile"];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    }
    else if (indexPath.section == 1) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
        topLine.backgroundColor = COLORHex(@"#cccccc");
        [view addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, tableView.frame.size.width, 0.5)];
        bottomLine.backgroundColor = COLORHex(@"#cccccc");
        [view addSubview:bottomLine];
        
        return view;
    }
    return nil;
}

#pragma mark - 显示电话电话拨打

- (void)showCall {
    NSString *phoneNumber = [VHSUtils absolutelyString:[[self.feedbackPhoneNmber.text componentsSeparatedByString:@":"] lastObject]];
    OneAlertCaller *caller = [[OneAlertCaller alloc] initWithNormalPhone:phoneNumber];
    [caller call];
}

#pragma mark - 提交反馈意见

- (void)postFeedbackSuggestion {
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_ADD_SUGGESTION;
    message.params = self.feedbackDict;
    message.httpMethod = VHSNetworkPOST;
    
    [MBProgressHUD showMessage:nil];
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:result[@"info"]];
        
        if ([result[@"result"] integerValue] != 200) return;
            
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
    
}

#pragma mark - fall keyboard

- (void)fallKeyboard {
    [self.view endEditing:YES];
}

@end
