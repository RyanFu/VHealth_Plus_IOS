//
//  VHSAllStepsController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/17.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSAllStepsController.h"
#import "VHSAllStepCell.h"
#import "MJRefresh.h"
#import "EveryDayStepModel.h"

@interface VHSAllStepsController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *stepsList;

@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation VHSAllStepsController

- (NSMutableArray *)stepsList {
    if (!_stepsList) {
        _stepsList = [NSMutableArray new];
    }
    return _stepsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageNum = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"所有步数";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.01)];
    footerView.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = footerView;
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, footerView.frame.size.width, 0.5)];
    topLine.backgroundColor = COLORHex(@"#cccccc");
    [footerView addSubview:topLine];
    
    [self setupRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)setupRefresh
{
    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefresh)];
    header.lastUpdatedTimeLabel.hidden = NO;
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.tableView.mj_header=header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupLoadMore)];
    [footer setTitle:@"释放加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    self.tableView.mj_footer = footer;
}

- (void)pulldownRefresh {
    [self.stepsList removeAllObjects];
    [self downloadSumSteps];
}

- (void)pullupLoadMore {
    self.currentPageNum++;
    [self downloadSumSteps];
}

// 步数明细
- (void)downloadSumSteps {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_MEMBER_STEP_KM_LIST;
    message.httpMethod = VHSNetworkPOST;
    message.params = @{@"currentPageNum" : [@(self.currentPageNum) stringValue]};
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSArray *resultList = result[@"resultList"];
            if ([resultList isKindOfClass:[NSArray class]]) {
                if (![resultList count]) {
                    self.currentPageNum--;
                    [VHSToast toast:TOAST_NOMORE_DATA];
                } else {
                    for (NSDictionary *dict in resultList) {
                        EveryDayStepModel *everyDay = [EveryDayStepModel yy_modelWithDictionary:dict];
                        [self.stepsList addObject:everyDay];
                    }
                    self.currentPageNum = [result[@"currentPageNum"] integerValue];
                }
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } fail:^(NSError *error) {}];
}


#pragma mark - UITableViewDelegate, DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stepsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VHSAllStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSAllStepCell"];
    EveryDayStepModel *model = self.stepsList[indexPath.row];
    cell.stepModel = model;
    return cell;
}

@end
