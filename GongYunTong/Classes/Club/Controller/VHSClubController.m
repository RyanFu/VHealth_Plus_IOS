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

@interface VHSClubController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong, nonnull) NSMutableArray<ClubModel *> *myClubList;       // 我的俱乐部
@property (nonatomic, strong, nonnull) NSMutableArray<ClubModel *> *allClubList;      // 所有俱乐部

@end

static NSString *reuse_identifier = @"VHSClubSessionCell";

@implementation VHSClubController

#pragma mark - override getter or setter method

- (NSMutableArray *)myClubList {
    if (!_myClubList) {
        _myClubList = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 4; i++) {
            ClubModel *club = [[ClubModel alloc] initWithIndex:i];
            [_myClubList addObject:club];
        }
    }
    return _myClubList;
}

- (NSMutableArray *)allClubList {
    if (!_allClubList) {
        _allClubList = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            ClubModel *club = [[ClubModel alloc] initWithIndex:i];
            [_allClubList addObject:club];
        }
    }
    return _allClubList;
}

#pragma mark - controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VHSClubSessionCell" bundle:nil] forCellReuseIdentifier:reuse_identifier];
    
    [self setupTableView];
    [self setupNavigationBarBtn];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    
    [self remoteUserClubs];
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
- (void)remoteUserClubs {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = @"";
    message.httpMethod = VHSNetworkPOST;
    message.params = @{};
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        for (NSDictionary *dict in result[@"myClubList"]) {
            ClubModel *club = [ClubModel yy_modelWithDictionary:dict];
            [self.myClubList addObject:club];
        }
    } fail:^(NSError *error) {
        
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
    cell.club = club;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClubModel *club = nil;
    if (0 == indexPath.section) {
        club = self.myClubList[indexPath.row];
    }
    else if (1 == indexPath.section) {
        club = self.allClubList[indexPath.row];
    }
    
    VHSChatController *chatVC = [[VHSChatController alloc] init];
    chatVC.conversationType = ConversationType_DISCUSSION;
    chatVC.targetId = club.targetId; // 目标会话ID - 当前为聊天室ID
    chatVC.title = club.title;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 12)];
    bgView.backgroundColor = COLORHex(@"EFEFF4");
    
    UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 1.0)];
    topline.backgroundColor = COLORHex(@"#E1E1E1");
    [bgView addSubview:topline];
    
    UIView *footline = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - 1, SCREENW, 1.0)];
    footline.backgroundColor = COLORHex(@"#E1E1E1");
    [bgView addSubview:footline];
    
    return bgView;
}

#pragma mark - 定义导航栏

- (void)setupNavigationBarBtn {
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(rightAddChat)];
}

- (void)rightAddChat {
    NSArray *userIdList = @[@"10010", @"10012", @"10013", @"100001"];
    
    [[RCIMClient sharedRCIMClient] createDiscussion:[userIdList componentsJoinedByString:@","]
                                         userIdList:userIdList
                                            success:^(RCDiscussion *discussion) {
                                             NSLog(@"创建讨论组成功，成员ID是: %@, 讨论组ID: %@", [discussion.memberIdList componentsJoinedByString:@"-"], discussion.discussionId);
                                         } error:^(RCErrorCode status) {
                                             NSLog(@"创建讨论组失败，错误码是: %@", @(status));
                                         }];
}

- (void)dealloc {
    CLog(@"VHSClubController be dealloc");
}

@end
