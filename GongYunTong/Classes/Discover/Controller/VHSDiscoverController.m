//
//  VHSDiscoverController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDiscoverController.h"
#import "VHSDiscoverCell.h"
#import "XLAlertController.h"
#import "XLAlertManager.h"
#import "BannerItemModel.h"
#import "PublicWKWebViewController.h"
#import "OneAlertCaller.h"
#import "VHSClubController.h"

// 一行显示的个数
NSInteger const ROW_COUNT = 3;

@interface VHSDiscoverController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView           *collectionView;

@property (nonatomic, strong)NSMutableArray                     *bannerList;

@end

@implementation VHSDiscoverController

#pragma mark - override getter method

- (NSMutableArray *)bannerList {
    if (!_bannerList) {
        _bannerList = [NSMutableArray new];
    }
    return _bannerList;
}

#pragma mark - Controller 生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 防止navigationBar挡住tableView/scrollView
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 先从缓存中读取数据
    NSArray *cacheDiscoverList = [VHSCommon getUserDefautForKey:Cache_Discover_BannerList];
    for (NSDictionary *dict in cacheDiscoverList) {
        BannerItemModel *model = [BannerItemModel yy_modelWithDictionary:dict];
        [self.bannerList addObject:model];
    }
    
    // 初始化flowLayout
    [self setupFlowLayout];
    [self downloadDiscoverItem];
    
    // 观察系统通知 - UIApplicationWillResignActiveNotification
    [k_NotificationCenter addObserver:self
                             selector:@selector(appWillResignActive)
                                 name:UIApplicationWillResignActiveNotification
                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setupFlowLayout {
    self.flowLayout.itemSize = CGSizeMake(SCREENW / ROW_COUNT, 0.8 * SCREENW / ROW_COUNT);
    self.flowLayout.minimumLineSpacing = 0.0f;
    self.flowLayout.minimumInteritemSpacing = 0.0f;
    self.flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 12);
}

#pragma mark - 获取服务端数据

- (void)downloadDiscoverItem{
    
    if (![VHSCommon isNetworkAvailable]) return;
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_DISCOVERY;
    message.httpMethod = VHSNetworkPOST;

    [self.bannerList removeAllObjects];
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        NSArray *bannerList = result[@"bannerList"];
        if (![bannerList isKindOfClass:[NSArray class]]) return;
        
        for (NSDictionary *itemDict in bannerList) {
            BannerItemModel *model = [BannerItemModel yy_modelWithDictionary:itemDict];
            [self.bannerList addObject:model];
        }
        
        //  补齐collection中cell
        NSInteger surplus = [self.bannerList count] % ROW_COUNT;
        if (surplus) {
            NSInteger completionNums = ROW_COUNT - surplus;
            for (NSInteger i = 0; i < completionNums; i++) {
                BannerItemModel *model = [[BannerItemModel alloc] init];
                [self.bannerList addObject:model];
            }
        }
        
        [self.collectionView reloadData];
        
    } fail:^(NSError *error) {
        CLog(@"%@",error);
    }];

}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.bannerList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VHSDiscoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VHSDiscoverCell class])
                                                                      forIndexPath:indexPath];
    cell.bannerItem = self.bannerList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BannerItemModel *model = self.bannerList[indexPath.row];
    // discoveryType : 1 链接 2 电话 3: 原生模块
    switch (model.discoveryType) {
        case 1:
        {
            PublicWKWebViewController *publicWebVC = [[PublicWKWebViewController alloc] init];
            publicWebVC.urlString = model.hrefUrl;
            publicWebVC.showTitle = YES;
            publicWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:publicWebVC animated:YES];
        }
            break;
        case 2:
        {
            OneAlertCaller *caller = [[OneAlertCaller alloc] initWithPhone:model.hrefUrl];
            [caller call];
        }
            break;
        case 3:
        {
            if ([model.hrefUrl isEqualToString:@"club"]) {
                VHSClubController *clubVC = [[VHSClubController alloc] init];
                clubVC.hidesBottomBarWhenPushed = YES;
                clubVC.title = model.title;
                [self.navigationController pushViewController:clubVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIApplicationWillResignActiveNotification
// 发现-缓存
- (void)appWillResignActive {
    NSMutableArray *cacheBannerList = [NSMutableArray new];
    for (BannerItemModel *model in self.bannerList) {
        NSDictionary *dict = [model transferToDict:model];
        [cacheBannerList addObject:dict];
    }
    [VHSCommon saveUserDefault:cacheBannerList forKey:Cache_Discover_BannerList];
}


@end
