//
//  VHSMeController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSMeController.h"
#import "VHSSettingController.h"
#import "VHSMyScoreController.h"
#import "VHSFeedbackController.h"
#import "UserHeadCell.h"
#import "UserInfoCell.h"
#import "UserScoreModel.h"
#import "UserDetailModel.h"
#import "VHSRecordStepController.h"
#import "VHSStepAlgorithm.h"
#import "VHSPersonInfoController.h"
#import "VHSFitBraceletStateManager.h"
#import "MeSumScoreModel.h"
#import "VHSMeScoreCell.h"
#import "VHSNoStypeCell.h"

@interface VHSMeController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UILabel                *copyright;
@property (weak, nonatomic) IBOutlet UIView                 *headerViewLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *headerViewLineHeight;

@property (nonatomic, strong) UserScoreModel                *userScore;
@property (nonatomic, strong) UserDetailModel               *userDetail;

@property (nonatomic, assign) NSInteger                     todaySteps;
@property (nonatomic, strong) NSString                      *servicePhoneNumber;
@property (nonatomic, strong) NSMutableDictionary           *feedbackDict;

@end

@implementation VHSMeController

- (NSInteger)todaySteps {
    return [[VHSStepAlgorithm shareAlgorithm] selecteSumStepsWithMemberId:[[VHSCommon userDetailInfo].memberId stringValue] date:[VHSCommon getYmdFromDate:[NSDate date]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我";
    self.headerViewLineHeight.constant = 0.5;
    // 获取版本信息
    self.copyright.text = [NSString stringWithFormat:@"版本%@ 由好人生集团提供", [VHSCommon appVersion]];
    
    // 先从缓存中读取数据
    self.userDetail = [VHSCommon userDetailInfo];
    self.userScore = [UserScoreModel yy_modelWithDictionary:[VHSCommon getUserDefautForKey:Cache_Me_UserScore]];
    
    [self getMemberScore];
    [self downloadUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", self.title]];
}

#pragma mark - download data 

- (void)getMemberScore {
    if (![VHSCommon isNetworkAvailable]) {
        return;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_MEMBER_SCORE;
    message.httpMethod = VHSNetworkPOST;
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            // 缓存数据
            [VHSCommon saveUserDefault:result forKey:Cache_Me_UserScore];
            
            self.userScore = [UserScoreModel yy_modelWithDictionary:result];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {}];
}

// 用户详细信息
- (void)downloadUserInfo {
    if (![VHSCommon isNetworkAvailable]) {
        return;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_MEMBER_DETAIL;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            [VHSCommon saveUserDefault:result forKey:k_User_Detail_Info];
            self.userDetail = [UserDetailModel yy_modelWithDictionary:result];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        DLog(@"用户详情 ---- %@", error.localizedDescription);
    }];
}


#pragma mark -tableview协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 15;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 176 / 2.0;
    }
    else if (indexPath.section == 1) {
        return 88;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 2;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 15)];
    view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    UIView *headline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 0.5)];
    headline.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [view addSubview:headline];
    
    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame) - 0.5, SCREENW, 0.5)];
    bottomline.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [view addSubview:bottomline];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserHeadCell *cell = (UserHeadCell *)[tableView dequeueReusableCellWithIdentifier:@"UserHeadCell" forIndexPath:indexPath];
        cell.headerImageUrl = self.userDetail.headerUrl;
        cell.cellTitle = self.userDetail.nickName;
        cell.cellInfo = [[self.userDetail.depts lastObject] objectForKey:@"deptName"];    // 获取末级部门名称，多级在具体详情中展示
        return cell;
    }
    else if (indexPath.section == 1) {        
        VHSMeScoreCell *cell = (VHSMeScoreCell *)[tableView dequeueReusableCellWithIdentifier:@"VHSMeScoreCell" forIndexPath:indexPath];
        cell.headerUrl = @"icon_jifen_";
        cell.scoreContent = @"积分";
        cell.scoreNumberContent = [NSString stringWithFormat:@"%@", self.userScore.score ? self.userScore.score : @(0)];
        cell.rateGoldContent = @"折合健康豆";
        cell.rateGoldNumberContent = [NSString stringWithFormat:@"%@", self.userScore.gold ? self.userScore.gold : @(0)];
        return cell;
    }
    else if (indexPath.section == 2) {
        UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
        cell.headerImageUrl = @"icon_steps";
        cell.cellTitle = @"计步";
        cell.cellInfo = [NSString stringWithFormat:@"今日%@步", @(self.todaySteps)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
            cell.headerImageUrl = @"icon_yijianfankui";
            cell.cellTitle = @"意见反馈";
            cell.cellInfo = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else if (indexPath.row == 1) {
            VHSNoStypeCell *cell = (VHSNoStypeCell *)[tableView dequeueReusableCellWithIdentifier:@"VHSNoStypeCell" forIndexPath:indexPath];
            cell.headerImageUrl = @"icon_kefu";
            cell.cellTitle = @"联系客服";
            cell.cellInfo = @"400-620-1800";
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
    }
    else if (indexPath.section == 4) {
        UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
        cell.headerImageUrl = @"icon_setting";
        cell.cellTitle = @"设置";
        cell.cellInfo = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // 个人详情
        VHSPersonInfoController *personVC = (VHSPersonInfoController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSPersonInfoController"];
        personVC.uploadHeadBlock = ^(NSString *headerUrl) {
            UserHeadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.headerImageUrl = headerUrl;
            self.userDetail.headerUrl = headerUrl;
        };
        personVC.hidesBottomBarWhenPushed = YES;
        personVC.detailModel = self.userDetail;
        [self.navigationController pushViewController:personVC animated:YES];
    }
    else if (indexPath.section == 1) {
        // 我的积分
        VHSMyScoreController *scoreVC = (VHSMyScoreController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSMyScoreController"];
        scoreVC.scoreModel = self.userScore;
        __weak __typeof(self)weakSelf = self;
        scoreVC.myscoreCallBack = ^(UserScoreModel *scoreModel) {
            weakSelf.userScore = scoreModel;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                              withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.navigationController pushViewController:scoreVC animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        // 计步
        __weak __typeof(self)weakSelf = self;
        VHSRecordStepController *recordStepVC = [[VHSRecordStepController alloc] init];
        recordStepVC.hidesBottomBarWhenPushed = YES;
        recordStepVC.callback = ^(NSInteger steps) {
            UserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.cellInfo = [NSString stringWithFormat:@"今日%ld步", (long)steps];
            weakSelf.todaySteps = steps;
        };
        recordStepVC.sumSteps = _todaySteps;
        [self.navigationController pushViewController:recordStepVC animated:YES];
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            // 意见反馈
            VHSFeedbackController *feedbackVC = (VHSFeedbackController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSFeedbackController"];
            feedbackVC.callBack = ^(NSMutableDictionary *feedbackDict) {
                self.feedbackDict = feedbackDict;
            };
            feedbackVC.feedbackDict = self.feedbackDict;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
        else if (indexPath.row == 1) {
            // 联系客服
            UserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.servicePhoneNumber = cell.cellInfo;
            UIActionSheet *callPhoneSheet = [[UIActionSheet alloc] initWithTitle:@"点击拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_servicePhoneNumber, nil];
            [callPhoneSheet showInView:self.view];
        }
    }
    else if (indexPath.section == 4) {
        // 设置
        VHSSettingController *settingVC = (VHSSettingController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSSettingController"];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSURL *servicePhoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_servicePhoneNumber]];
        if ([[UIApplication sharedApplication] canOpenURL:servicePhoneUrl]) {
            [[UIApplication sharedApplication] openURL:servicePhoneUrl];
        }
    }
}

@end
