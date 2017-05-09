//
//  VHSDynamicHomeController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDynamicHomeController.h"
#import "VHSDynamicBannerCell.h"
#import "VHSDynamicBigIgvCell.h"
#import "VHSSinglePicCell.h"
#import "VHSMoreIgvCell.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "MBProgressHUD+VHS.h"
#import "DynamicItemModel.h"
#import "VHSFitBraceletStateManager.h"
#import "VHSStepAlgorithm.h"
#import "PublicWKWebViewController.h"
#import "VHSEnterpriseDynamicCell.h"
#import "VHSDynamicConfigurationCell.h"
#import "IconItem.h"
#import "NSString+extension.h"
#import "OneAlertCaller.h"
#import "VHSRecordStepController.h"
#import "VHSMyScoreController.h"

@interface VHSDynamicHomeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView    * dynamicHomeTable;
@property (nonatomic, strong) NSArray               * arrBannerList;
@property (nonatomic, strong) NSMutableArray        * dynamicList;
@property (nonatomic, strong) NSMutableArray        * configIconList;   // 首页配置按钮
@property (nonatomic, assign) NSInteger             currentPageNum;  // 分页，页码

@property (nonatomic, assign) BOOL                  isRelogining;     // 重复登录中

@end

@implementation VHSDynamicHomeController

#pragma mark - override getter method

- (NSMutableArray *)configIconList {
    if (!_configIconList) {
        _configIconList = [NSMutableArray new];
    }
    return _configIconList;
}

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
    
    //    self.navigationItem.title = @"动态";
    self.currentPageNum = 1;
    
    // 缓存中读取动态列表数据
    self.arrBannerList = [VHSCommon getUserDefautForKey:Cache_Dynamic_BannerList];
    NSArray *cacheDynamicList = [VHSCommon getUserDefautForKey:Cache_Dynamic_DynamicList];
    for (NSDictionary *dict in cacheDynamicList) {
        [self.dynamicList addObject:[DynamicItemModel yy_modelWithDictionary:dict]];
    }
    
    // 缓存读取配置icon的信息
    NSArray *cacheConfigIconList = [VHSCommon getUserDefautForKey:Cache_Config_Icon];
    for (NSDictionary *dict in cacheConfigIconList) {
        [self.configIconList addObject:[IconItem yy_modelWithDictionary:dict]];
    }
    
    //  初始化refresh
    [self setupRefresh];
    
    // 监测版本升级
    [self checkVersion];
    // 获取导航列表
    [self loadIconList];
    
    // 观察系统通知 - UIApplicationWillResignActiveNotification
    [k_NotificationCenter addObserver:self
                             selector:@selector(appWillResignActive)
                                 name:UIApplicationWillResignActiveNotification
                               object:nil];
    [k_NotificationCenter addObserver:self
                             selector:@selector(appWillEnterForeground)
                                 name:UIApplicationWillEnterForegroundNotification
                               object:nil];
    [k_NotificationCenter addObserver:self
                             selector:@selector(relogin:)
                                 name:k_NOTIFICATION_TOKEN_INVALID
                               object:nil];
//    [k_NotificationCenter addObserver:self
//                             selector:@selector(doubleClickTabbarItemAction)
//                                 name:k_NOTI_DOUBLE_CLICK_TABBAR
//                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    float appVersion = [[VHSCommon getUserDefautForKey:k_APPVERSION] floatValue];
    if (appVersion < [[VHSCommon appVersion] floatValue]) {
        [VHSAlertController alertMessage:@"当前版本已升级，请重新登陆，已绑定手环需要重新绑定" confirmHandler:^(UIAlertAction *action) {
            [self relogin:nil];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self tableViewIfNeededRefresh];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [VHSCommon saveDynamicTime:[VHSCommon getDate:[NSDate date]]];
}

- (void)tableViewIfNeededRefresh {
    // 超过时间一个小时，自动刷新
    NSString *latelyTime = [VHSCommon getUserDefautForKey:k_Late_Show_Dynamic_Time];
    
    if ([VHSCommon intervalSinceNow:latelyTime] < k_Late_Duration(1.0)) return;
    
    [self.dynamicHomeTable.mj_header beginRefreshing];
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

#pragma mark - networker interface

- (void)loadNewData {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_INDEX_BANNER;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        if ([result[@"bannerList"] isKindOfClass:[NSArray class]]) {
            self.arrBannerList = result[@"bannerList"];
        }
    } fail:^(NSError *error) {
        CLog(@"%@",error);
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
    } else {
        self.currentPageNum = 1;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_INDEX_DYNAMIC;
    message.params = @{@"currentPageNum" : [@(self.currentPageNum) stringValue]};
    message.httpMethod = VHSNetworkGET;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        
        if ([result[@"result"] integerValue] != 200) return;
        
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
        
        [self.dynamicHomeTable reloadData];
        [self.dynamicHomeTable.mj_header endRefreshing];
        [self.dynamicHomeTable.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self.dynamicHomeTable.mj_header endRefreshing];
        [self.dynamicHomeTable.mj_footer endRefreshing];
    }];
}

- (void)checkVersion {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_VERSION;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        NSString *content = result[@"content"];
        BOOL isForceUpgrade = [result[@"isForce"] boolValue];
        float serverVersion = [result[@"upgradeVersion"] floatValue];
        float appVersion = [[VHSCommon appVersion] floatValue];
        NSString *loadUrl = result[@"url"];
        
        if (serverVersion <= appVersion) return;
        
        OneAlertCaller *caller = [[OneAlertCaller alloc] initWithContent:content forceUpgrade:isForceUpgrade downloadUrl:loadUrl];
        [caller call];
        
    } fail:^(NSError *error) {}];
}

- (void)loadIconList {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.httpMethod = VHSNetworkPOST;
    message.path = URL_GET_ICON;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        if ([self.configIconList count]) {
            [self.configIconList removeAllObjects];
        }
        
        for (NSDictionary *dic in result[@"iconList"]) {
            IconItem *item = [IconItem yy_modelWithDictionary:dic];
            [self.configIconList addObject:item];
        }
        
        [self.dynamicHomeTable reloadSections:[NSIndexSet indexSetWithIndex:1]
                             withRowAnimation:UITableViewRowAnimationFade];
        
    } fail:^(NSError *error) {
        CLog(@"error = %@", error.description);
    }];
}

#pragma mark - tableView协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 1;
    }
    else if (section == 3) {
        return [self.dynamicList count];
    }
    return 0;
}

// 将banner放到cell中，单独分区（第0区），剩下的3种样式放到一个区中，建议服务器将3种展示样式的数据放到一个json中，添加区分3种样式的字段
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return SCREENW * 0.4667;
        }
            break;
        case 1: {
            NSInteger count = [self.configIconList count];
            if (count == 0) {
                return 0;
            }
            else if (count % 4 == 0) {
                return 90 * (count / 4) * ratioW + 15;
            }
            else if (count % 4 != 0) {
                return 90 * (1 + count / 4) * ratioW + 5 * (count / 4) + 15;
            }
            return 0;
        }
            break;
        case 2: {
            return 49.0 * ratioH;
        }
            break;
        case 3: {
            DynamicItemModel *item = self.dynamicList[indexPath.row];
            NSString *dynamicZyText = item.dynamicZyText;
            
            CGFloat floatHight = [dynamicZyText computerWithSize:CGSizeMake(SCREENW - 40, CGFLOAT_MAX)
                                                            font:[UIFont systemFontOfSize:15]].height;
            if ([VHSCommon isNullString:dynamicZyText]) {
                floatHight = 0;
            } else if (floatHight > 36) {
                // 文本超过两行
                floatHight = 36.0;
            }
            
            if ([item.imgType integerValue] == 1) {
                // 单图
                if (floatHight < 18.0) floatHight = 36;
                
                return 81.0 + floatHight;
            }
            else if ([item.imgType integerValue] == 2) {
                // 大图
                return 60 + 295 * ratioH + floatHight;
            }
            else if ([item.imgType integerValue] == 3) {
                // 三图
                return 95 + 83 * ratioH + floatHight;
            }
        }
        default: {
            return 0;
        }
            break;
    }
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
        VHSDynamicConfigurationCell *cell = [[VHSDynamicConfigurationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VHSDynamicConfigurationCell"];
        cell.configurationList = self.configIconList;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iconCallBack = ^(IconItem *item) {
            
            if (item.iconType == 1) {
                // 跳转到webView
                PublicWKWebViewController *webView = [[PublicWKWebViewController alloc] init];
                webView.urlString = item.iconHref;
                webView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webView animated:YES];
            }
            else if (item.iconType == 2) {
                // 我的积分
                VHSMyScoreController *scoreVC = (VHSMyScoreController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSMyScoreController"];
                scoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scoreVC animated:YES];
            }
            else if (item.iconType == 3) {
                // 一键呼
                OneAlertCaller *caller = [[OneAlertCaller alloc] initWithPhone:[VHSUtils formatterMobile:item.iconHref]];
                [caller call];
            }
            else if (item.iconType == 4) {
                // 切换tabbar到福利
                [self.tabBarController setSelectedIndex:2];
            }
            else if (item.iconType == 5) {
                // 活动签到
                VHSRequestMessage *msg = [[VHSRequestMessage alloc] init];
                msg.path = URL_ADD_CHECKIN_DAY;
                msg.httpMethod = VHSNetworkPOST;
                
                [[VHSHttpEngine sharedInstance] sendMessage:msg success:^(NSDictionary *result) {
                    [VHSToast toast:result[@"info"]];
                } fail:^(NSError *error) {
                    CLog(@"%@", error.description);
                }];
            }
            else if (item.iconType == 6) {
                // 计步更新
                VHSRecordStepController *stepVC = [[VHSRecordStepController alloc] init];
                stepVC.todayStep = [VHSGlobalDataManager shareGlobalDataManager].recordAllSteps;
                stepVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:stepVC animated:YES];
            }
        };
        return cell;
    }
    else if (indexPath.section == 2) {
        VHSEnterpriseDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VHSEnterpriseDynamicCell class])];
        return cell;
    }
    else if (indexPath.section == 3) {
        DynamicItemModel *item = self.dynamicList[indexPath.row];
        if ([item.imgType integerValue] == 1) {
            // 单图
            VHSSinglePicCell *singleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VHSSinglePicCell class])];
            singleCell.dynamicItem = item;
            return singleCell;
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
    
    if (indexPath.section == 3) {
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

#pragma mark - Notification

/// token 失效 重新登录
- (void)relogin:(NSNotification *)noti {
    if (self.isRelogining) {
        return;
    }
    self.isRelogining = YES;
    // 先注销信息
    // 用户信息清除
    [VHSCommon removeLocationUserInfo];
    
    NSString *toast = [noti.userInfo objectForKey:@"info"];
    if (![VHSCommon isNullString:toast]) {
        [VHSToast toast:toast];
    } else {
        [MBProgressHUD show];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        UIWindow *wind = [UIApplication sharedApplication].delegate.window;
        wind.rootViewController = vc;
    });
}

- (void)appWillResignActive {
    // 缓存列表信息
    NSMutableArray *cacheDynamicList = [NSMutableArray new];
    for (DynamicItemModel *model in self.dynamicList) {
        [cacheDynamicList addObject:[model transferToDict]];
    }
    [VHSCommon saveUserDefault:self.arrBannerList forKey:Cache_Dynamic_BannerList];
    [VHSCommon saveUserDefault:cacheDynamicList forKey:Cache_Dynamic_DynamicList];
    
    // 缓存icon的列表信息
    NSMutableArray *cacheIconList = [NSMutableArray new];
    for (IconItem *iconItem in self.configIconList) {
        [cacheIconList addObject:[iconItem transferToDic]];
    }
    [VHSCommon saveUserDefault:cacheIconList forKey:Cache_Config_Icon];
}

- (void)appWillEnterForeground {
    if (!self.isVisible) {
        return;
    }
    [self tableViewIfNeededRefresh];
}

- (void)doubleClickTabbarItemAction {
    if (self.isVisible) {
        [self.dynamicHomeTable setContentOffset:CGPointZero animated:YES];
    }
}


- (void)dealloc {
    CLog(@"dynamic - dealloc");
}

@end
