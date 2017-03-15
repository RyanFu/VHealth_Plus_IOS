//
//  VHSClubController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSClubController.h"
#import "ClubModel.h"
#import "VHSChatController.h"
#import "VHSClubSessionCell.h"
#import "PublicWKWebViewController.h"
#import "ThirdPartyCoordinator.h"

typedef NS_ENUM(NSUInteger, VHSClubType) {
    VHSClubOfMeType,        // 我的俱乐部
    VHSClubOfOtherType      // 其他俱乐部
};

@interface VHSClubController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong, nonnull) NSMutableArray<ClubModel *> *myClubList;       // 我的俱乐部
@property (nonatomic, strong, nonnull) NSMutableArray<ClubModel *> *allClubList;      // 所有俱乐部

@end

static NSString *reuse_identifier = @"VHSClubSessionCell";
static NSInteger load_club_numbers = 0;

@implementation VHSClubController

#pragma mark - override getter or setter method

- (NSMutableArray *)myClubList {
    if (!_myClubList) {
        _myClubList = [NSMutableArray array];
    }
    return _myClubList;
}

- (NSMutableArray *)allClubList {
    if (!_allClubList) {
        _allClubList = [NSMutableArray array];
    }
    return _allClubList;
}

#pragma mark - controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 没有初始化过融云SDK
    if (load_club_numbers == 0) {
        [[ThirdPartyCoordinator shareCoordinator] setupRCKit];
        load_club_numbers = 1;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VHSClubSessionCell" bundle:nil] forCellReuseIdentifier:reuse_identifier];
    
    [self setupTableView];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    
    [self remoteUserClubsWithClubType:VHSClubOfMeType];
    [self remoteUserClubsWithClubType:VHSClubOfOtherType];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:VC_TITLE_CLUB];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:VC_TITLE_CLUB];
}

#pragma mark - 初始化试图

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - NAVIAGTION_HEIGHT)
                                                  style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 10)];
    headerView.backgroundColor = COLORHex(@"#EFEFF4");
    
    UIView *footline = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, SCREENW, 1.0)];
    footline.backgroundColor = COLORHex(@"#E1E1E1");
    [headerView addSubview:footline];
    
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 服务器获取信息

/// 获取用户俱乐部所在的俱乐部信息
- (void)remoteUserClubsWithClubType:(VHSClubType)type {
    NSString *clubType = nil;
    if (VHSClubOfMeType == type) {
        clubType = @"me";
    } else if (VHSClubOfOtherType == type) {
        clubType = @"other";
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_CLUB_LIST;
    message.httpMethod = VHSNetworkPOST;
    message.params = @{@"type" : clubType, @"currentPageNum" : @"1"};
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        if (VHSClubOfMeType == type) [self.myClubList removeAllObjects];
        
        for (NSDictionary *dict in result[@"clubList"]) {
            ClubModel *club = [ClubModel yy_modelWithDictionary:dict];
        
            if (VHSClubOfMeType == type) {
                [self.myClubList addObject:club];
            } else if (VHSClubOfOtherType == type) {
                [self.allClubList addObject:club];
            }
        }
    
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        CLog(@"error - %@", error.description);
    }];
}

#pragma mark - UITableViewDelegate,Source 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return [self.myClubList count];
    }
    else if (1 == section) {
        return [self.allClubList count];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClubModel *club = nil;
    if (0 == indexPath.section) {
        club = self.myClubList[indexPath.row];
    }
    else if (1 == indexPath.section) {
        club = self.allClubList[indexPath.row];
    }
    
    VHSClubSessionCell *cell = (VHSClubSessionCell *)[tableView dequeueReusableCellWithIdentifier:reuse_identifier];
    if (nil == cell) {
        cell = (VHSClubSessionCell *)[[[NSBundle mainBundle] loadNibNamed:@"VHSClubSessionCell"
                                                                    owner:self
                                                                  options:nil] lastObject];
    }
    // section最后一行显示分割视图
    if (indexPath.section == 0 && ([self.myClubList count] - 1) == indexPath.row) {
        club.haveFooter = YES;
    }
    
    cell.club = club;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClubModel *club = nil;
    if (0 == indexPath.section) {
        club = self.myClubList[indexPath.row];
        
        VHSChatController *chatVC = [[VHSChatController alloc] init];
        chatVC.conversationType = ConversationType_GROUP;
        chatVC.targetId = club.rongGroupId; // 目标会话ID - 当前为群组ID
        chatVC.title = club.clubName;
        chatVC.club = club;
        chatVC.clubChatCallBack = ^(ClubModel *club){
            [self.myClubList removeObject:club];
            [self.allClubList insertObject:club atIndex:0];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else if (1 == indexPath.section) {
        club = self.allClubList[indexPath.row];
    
        // "所有俱乐部"点击跳转到俱乐部详情页面
        PublicWKWebViewController *publicWeb = [[PublicWKWebViewController alloc] init];
        publicWeb.urlString = club.clubUrl;
        publicWeb.title = club.clubName;
        [self.navigationController pushViewController:publicWeb animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // section最后一行显示分割视图
    if (indexPath.section == 0 && ([self.myClubList count] - 1) == indexPath.row) {
        return 99 + 15;
    }
    return 99;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 45)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREENW - 20, 20)];
    headerLabel.textColor = [UIColor blackColor];
    [bgView addSubview:headerLabel];
    
    UIView *footline = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame) - 1, SCREENW, 0.7)];
    footline.backgroundColor = COLORHex(@"#BBBBBB");
    [bgView addSubview:footline];
    
    if (0 == section) {
        headerLabel.text = @"我的俱乐部";
    }
    else if (1 == section) {
        headerLabel.text = @"所有俱乐部";
    }
    
    return bgView;
}

- (void)dealloc {
    CLog(@"VHSClubController be dealloc");
}

@end
