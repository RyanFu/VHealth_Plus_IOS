//
//  VHSDynamicHomeController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 lucky. All rights reserved.
//
// will add swift to project

#import "VHSDynamicHomeController.h"
#import "VHSDynamicBannerCell.h"
#import "VHSDynamicBigIgvCell.h"
#import "VHSAboutSpaceCell.h"
#import "VHSMoreIgvCell.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "MBProgressHUD+VHS.h"
#import "DynamicItemModel.h"
#import "VHSFitBraceletStateManager.h"
#import "VHSStepAlgorithm.h"
#import "PublicWKWebViewController.h"
#import "SharePeripheral.h"

@interface VHSDynamicHomeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView    * dynamicHomeTable;
@property (nonatomic, strong) NSArray               * arrBannerList;
@property (nonatomic, strong) NSMutableArray        * dynamicList;
@property (nonatomic, assign) NSInteger             currentPageNum;  // 分页，页码

@property (nonatomic, assign) BOOL                  isRelogining;     // 重复登录中

@end

@implementation VHSDynamicHomeController

#pragma mark - override getter method

- (NSMutableArray *)dynamicList {
    if (!_dynamicList) {
        _dynamicList = [NSMutableArray new];
    }
    return _dynamicList;
}

- (NSArray *)arrBannerList {
    if (!_arrBannerList) {
        _arrBannerList = [NSMutableArray new];
    }
    return _arrBannerList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 防止navigationBar挡住tableView
    self.automaticallyAdjustsScrollViewInsets = false;
    self.dynamicHomeTable.backgroundColor = COLORHex(@"#EFEFF4");
    
    self.navigationItem.title = @"动态";
    self.currentPageNum = 1;
    
    // 缓存中读取数据
    self.arrBannerList = [k_UserDefaults objectForKey:Cache_Dynamic_BannerList];
    NSArray *cacheDynamicList = [k_UserDefaults objectForKey:Cache_Dynamic_DynamicList];
    for (NSDictionary *dict in cacheDynamicList) {
        [self.dynamicList addObject:[DynamicItemModel yy_modelWithDictionary:dict]];
    }
    
    //  初始化refresh
    [self setupRefresh];
    
    // 监测版本升级
    [self checkVersion];
    
    // 观察系统通知 - UIApplicationWillResignActiveNotification
    [k_NotificationCenter addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [k_NotificationCenter addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [k_NotificationCenter addObserver:self selector:@selector(relogin:) name:k_NOTIFICATION_TOKEN_INVALID object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"动态"];
    [self tableViewIfNeededRefresh];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"动态"];
}

- (void)tableViewIfNeededRefresh {
    // 超过时间一个小时，自动刷新
    NSString *lateTime = [k_UserDefaults objectForKey:k_Late_Show_Dynamic_Time];
    if ([VHSCommon intervalSinceNow:lateTime] >= k_Late_Duration(1.0)) {
        [self.dynamicHomeTable.mj_header beginRefreshing];
    }
    [VHSCommon saveDynamicTime:[VHSCommon getDate:[NSDate date]]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setupRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = NO;
    header.labelLeftInset = 30;
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.dynamicHomeTable.mj_header = header;
    [self.dynamicHomeTable.mj_header beginRefreshing];
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"释放加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    self.dynamicHomeTable.mj_footer = footer;
}

- (void)refreshData {
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_NO_NETWORK];
        [self.dynamicHomeTable.mj_header endRefreshing];
        [self.dynamicHomeTable.mj_footer endRefreshing];
        return;
    }

    [self loadNewData];
    [self loadMoreDataIsRefresh:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(k_REFRESH_TIME_OUT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dynamicHomeTable.mj_header endRefreshing];
    });
}

- (void)loadNewData {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_INDEX_BANNER;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            if ([result[@"bannerList"] isKindOfClass:[NSArray class]]) {
                self.arrBannerList = result[@"bannerList"];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadMoreData {
    [self loadMoreDataIsRefresh:NO];
}

-(void)loadMoreDataIsRefresh:(BOOL)isRefresh {
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_NO_NETWORK];
        [self.dynamicHomeTable.mj_header endRefreshing];
        [self.dynamicHomeTable.mj_footer endRefreshing];
        return;
    }
    
    if (!isRefresh) {
        self.currentPageNum++;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_INDEX_DYNAMIC;
    message.params = @{@"currentPageNum" : @(self.currentPageNum)};
    message.httpMethod = VHSNetworkGET;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            // 下拉刷新的情况下移除所有旧对象
            if (isRefresh) {
                [self.dynamicList removeAllObjects];
            }
            if ([result[@"dyList"] isKindOfClass:[NSArray class]]) {
                NSArray *dyList = result[@"dyList"];
                if (![dyList count]) {
                    self.currentPageNum--;
                    [VHSToast toast:TOAST_NOMORE_DATA];
                }
                else {
                    self.currentPageNum = [result[@"currentPageNum"] integerValue];
                    for (NSDictionary *dyItem in dyList) {
                        [self.dynamicList addObject:[DynamicItemModel yy_modelWithDictionary:dyItem]];
                    }
                }
            }
        }
        [self.dynamicHomeTable reloadData];
        [self.dynamicHomeTable.mj_header endRefreshing];
        [self.dynamicHomeTable.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self.dynamicHomeTable.mj_header endRefreshing];
        [self.dynamicHomeTable.mj_footer endRefreshing];
        NSLog(@"error = %@", error);
    }];
}

- (void) checkVersion {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_VERSION;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        NSString *content = result[@"content"];
        BOOL isForceUpgrade = [result[@"isForce"] boolValue];
        float serverVersion = [result[@"upgradeVersion"] floatValue];
        float appVersion = [[VHSCommon appVersion] floatValue];
        if (serverVersion > appVersion) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"版本更新" message:content preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (isForceUpgrade) {
                    exit(0);
                }
            }];
            [alertVC addAction:cancelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 跳转到appStore
                [VHSCommon toAppStoreForUpgrade];
            }];
            [alertVC addAction:confirmAction];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } fail:^(NSError *error) {}];
}

#pragma mark - tableView协议
/*
 * 将banner放到cell中，单独分区（第0区），剩下的3种样式放到一个区中，建议服务器将3种展示样式的数据放到一个json中，添加区分3种样式的字段
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCREENW * 0.4667 + 12;
    }
    else if (indexPath.section == 1) {
        DynamicItemModel *item = self.dynamicList[indexPath.row];
        
        if ([item.imgType integerValue] == 1) {
            // 单图
            return (93.0 / 375) * SCREENW;
        }
        else if ([item.imgType integerValue] == 2) {
            // 大图
            return (240.0 / 375) * SCREENW;
        }
        else if ([item.imgType integerValue] == 3) {
            // 三图
            return (165.0 / 375) * SCREENW;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [self.dynamicList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.arrBannerList.count; i++) {
            [arr addObject:[[_arrBannerList objectAtIndex:i] objectForKey:@"imgUrl"]];
        }
        
        VHSDynamicBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VHSDynamicBannerCell class])];
        bannerCell.bannerView.delegate = self;
        bannerCell.bannerView.imageURLStringsGroup = arr;
        return bannerCell;
    }
    else if (indexPath.section == 1) {
        DynamicItemModel *item = self.dynamicList[indexPath.row];
        if ([item.imgType integerValue] == 1) {
            // 单图
            VHSAboutSpaceCell *spaceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VHSAboutSpaceCell class])];
            spaceCell.dynamicItem = item;
            return spaceCell;
        }
        else if ([item.imgType integerValue] == 2) {
            // 大图
            VHSDynamicBigIgvCell *bigIgvCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VHSDynamicBigIgvCell class])];
            bigIgvCell.dynamicItem = item;
            return bigIgvCell;
        }
        else if ([item.imgType integerValue] == 3){
            // 三图
            VHSMoreIgvCell *moreIgvCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VHSMoreIgvCell class])];
            moreIgvCell.dynamicItem = item;
            return moreIgvCell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        // 跳到下一个页面，加载html
        DynamicItemModel *item = self.dynamicList[indexPath.row];
        
        PublicWKWebViewController *publicWebVC = [[PublicWKWebViewController alloc] init];
        publicWebVC.urlString = item.hrefUrl;
        publicWebVC.showTitle = NO;
        publicWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publicWebVC animated:YES];
        publicWebVC.hidesBottomBarWhenPushed = NO;
    }
    
    [self.dynamicHomeTable deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    PublicWKWebViewController *publicWebVC = [[PublicWKWebViewController alloc] init];
    publicWebVC.urlString = [[self.arrBannerList objectAtIndex:index] objectForKey:@"hrefUrl"];
    publicWebVC.showTitle = NO;
    publicWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publicWebVC animated:YES];
}

#pragma mark - UIApplicationWillResignActiveNotification

- (void)appWillResignActive {
    // 缓存列表信息
    NSMutableArray *cacheDynamicList = [NSMutableArray new];
    for (DynamicItemModel *model in self.dynamicList) {
        [cacheDynamicList addObject:[model transferToDict]];
    }
    [k_UserDefaults setObject:self.arrBannerList forKey:Cache_Dynamic_BannerList];
    [k_UserDefaults setObject:cacheDynamicList forKey:Cache_Dynamic_DynamicList];
    [k_UserDefaults synchronize];
}

- (void)appWillEnterForeground {
    if (!self.isVisible) {
        return;
    }
    [self tableViewIfNeededRefresh];
}

#pragma mark - token 失效 重新登录

- (void)relogin:(NSNotification *)noti {
    if (self.isRelogining) {
        return;
    }
    self.isRelogining = YES;
    // 先注销信息
    // 用户信息清除
    [VHSCommon removeLocationUserInfo];
    
    [VHSToast toast:[noti.userInfo objectForKey:@"info"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        UIWindow *wind = [UIApplication sharedApplication].delegate.window;
        wind.rootViewController = vc;
    });
}

- (void)dealloc {
    NSLog(@"dynamic - dealloc");
}

@end
