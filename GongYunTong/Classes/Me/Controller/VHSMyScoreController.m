//
//  VHSMyScoreController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSMyScoreController.h"
#import "VHSNormalCell.h"
#import "VHSPaymentsDetailCell.h"
#import "BalanceItemModel.h"
#import "MeSumScoreModel.h"

@interface VHSMyScoreController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray        *scoreItemList;
@property (nonatomic, assign) NSInteger              currentPageNum; // 分页
@property (nonatomic, strong) NSString              *goldRate;      // 积分转化金币比例

@end

@implementation VHSMyScoreController

- (NSMutableArray *)scoreItemList {
    if (!_scoreItemList) {
        _scoreItemList = [NSMutableArray new];
    }
    return _scoreItemList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageNum = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupRefresh];
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)getMemberScore {
    if (![VHSCommon isNetworkAvailable]) {
        return;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_MEMBER_SCORE;
    message.httpMethod = VHSNetworkPOST;
    @WeakObj(self);
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            selfWeak.scoreModel = [UserScoreModel yy_modelWithDictionary:result];
            if (selfWeak.myscoreCallBack) {
                selfWeak.myscoreCallBack(selfWeak.scoreModel);
            }
        }
        [selfWeak.tableView reloadData];
    } fail:^(NSError *error) {}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupRefresh {
    
//    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    header.lastUpdatedTimeLabel.hidden = NO;
//    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
//    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    self.tableView.mj_header = header;
//    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"释放加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    self.tableView.mj_footer = footer;
}

- (void)refreshData {
    if (![VHSCommon isNetworkAvailable]) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    _currentPageNum = 1;
    [self.scoreItemList removeAllObjects];
    [self getMemberScore];
    [self downloadCompanyGoldRate];
    [self downloadScoreList];
}

- (void)loadMoreData {
    _currentPageNum++;
    [self downloadScoreList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadCompanyGoldRate {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_COMPANY_COLD_RATE;
    message.httpMethod = VHSNetworkPOST;
    
    @WeakObj(self);
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        selfWeak.goldRate = result[@"goldRate"];
        [selfWeak.tableView reloadData];
    } fail:^(NSError *error) {}];
}

- (void)downloadScoreList {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.params = @{@"currentPageNum" : [@(_currentPageNum) stringValue]};
    message.path = URL_GET_MEMBER_SCORE_LIST;
    message.httpMethod = VHSNetworkPOST;
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSArray *scoreItemList = result[@"scoreItemList"];
            if ([scoreItemList isKindOfClass:[NSArray class]]) {
                if ([scoreItemList count] == 0) {
                    [VHSToast toast:TOAST_NOMORE_DATA];
                    self.currentPageNum--;
                } else {
                    self.currentPageNum = [result[@"currentPageNum"] integerValue];
                    for (NSDictionary *scoreDict in scoreItemList) {
                        BalanceItemModel *item = [BalanceItemModel yy_modelWithDictionary:scoreDict];
                        [self.scoreItemList addObject:item];
                    }
                }
                [self.tableView reloadData];
            }
        } else {
            _currentPageNum--;
            [VHSToast toast:result[@"info"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate,DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        // 取决服务器数据源
        return [self.scoreItemList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VHSNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSNormalCell"];
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.shouldHiddenLine = YES;
        }
        
        if (indexPath.row == 0) {
            cell.title.text = @"我的积分";
            cell.detail.text = [NSString stringWithFormat:@"%@", self.scoreModel.score ? self.scoreModel.score : @(0)];
        }
        else if (indexPath.row == 1) {
            cell.tagImageView.hidden = YES;
            cell.title.text = @"折合健康豆";
            cell.detail.text = [NSString stringWithFormat:@"%@", self.scoreModel.gold ? self.scoreModel.gold : @(0)];
        }
        else if (indexPath.row == 2) {
            cell.tagImageView.hidden = YES;
            cell.title.text = @"积分转换健康豆比例";
            cell.detail.text = self.goldRate;
        }
        return cell;
        
    } else {
        VHSPaymentsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSPaymentsDetailCell"];
        BalanceItemModel *balanceItem = self.scoreItemList[indexPath.row];
        cell.balanceItem = balanceItem;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, tableView.frame.size.width, 45 - 15)];
        titleLabel.text = @"收支明细";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = RGBCOLOR(33.0, 33.0, 33.0);
        bgView.backgroundColor = COLORHex(@"#EFEFF4");
        [bgView addSubview:titleLabel];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
        topLine.backgroundColor = COLORHex(@"#cccccc");
        [bgView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - 0.5, tableView.frame.size.width, 0.5)];
        bottomLine.backgroundColor = COLORHex(@"#cccccc");
        [bgView addSubview:bottomLine];
        
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 45;
    }
    return 0;
}

@end
