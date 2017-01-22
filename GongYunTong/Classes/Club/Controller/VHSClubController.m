//
//  VHSClubController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSClubController.h"
#import "ClubSectionModel.h"
#import "ClubModel.h"
#import "VHSChatController.h"
#import "VHSClubSessionCell.h"

@interface VHSClubController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *clubList;

@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *discusstionName;

@end

static NSString *reuse_identifier = @"VHSClubSessionCell";

@implementation VHSClubController

- (NSMutableArray *)clubList {
    if (!_clubList) {
        _clubList = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 3; i++) {
            ClubSectionModel *sectionClubModel = [[ClubSectionModel alloc] initWithIndex:i];
            [_clubList addObject:sectionClubModel];
        }
    }
    return _clubList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VHSClubSessionCell" bundle:nil]
         forCellReuseIdentifier:reuse_identifier];
    
    [self setupTableView];
    [self setupNavigationBarBtn];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
}

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

#pragma mark - UITableViewDelegate,Source 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.clubList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ClubSectionModel *sectionClubModel = self.clubList[section];
    return [sectionClubModel.clubList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClubSectionModel *clubSection = self.clubList[indexPath.section];
    ClubModel *club = clubSection.clubList[indexPath.row];

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
    
    ClubSectionModel *clubSection = self.clubList[indexPath.section];
    ClubModel *club = clubSection.clubList[indexPath.row];
    
    VHSChatController *chatVC = [[VHSChatController alloc] init];
    chatVC.conversationType = ConversationType_DISCUSSION;
    chatVC.targetId = self.targetId;
//    chatVC.title = club.title;
    chatVC.title = self.discusstionName;
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
    
    ClubSectionModel *clubSection = self.clubList[section];
    headerLabel.text = clubSection.title;
    
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
                                             self.discusstionName = discussion.discussionName;
                                             self.targetId = discussion.discussionId;
                                             NSLog(@"创建讨论组成功，成员ID是: %@, 讨论组ID: %@", [discussion.memberIdList componentsJoinedByString:@"-"], discussion.discussionId);
                                         } error:^(RCErrorCode status) {
                                             NSLog(@"创建讨论组失败，错误码是: %@", @(status));
                                         }];
}

@end
