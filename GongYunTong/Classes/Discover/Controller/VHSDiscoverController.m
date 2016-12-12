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
#import "OnekeyCall.h"

//一行显示的个数
NSInteger const ROWCOUNT = 3;
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

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"发现";
    
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
    [self getIconFromServer];
    
    // 观察系统通知 - UIApplicationWillResignActiveNotification
    [k_NotificationCenter addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", @"发现"]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", @"发现"]];
}

-(void)setupFlowLayout {
    self.flowLayout.itemSize = CGSizeMake(SCREENW / ROWCOUNT, 101.0 / 375 * SCREENW);
    self.flowLayout.minimumLineSpacing = 0.0f;
    self.flowLayout.minimumInteritemSpacing = 0.0f;
    self.flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 12);
}

- (void)getIconFromServer{
    
    if (![VHSCommon isNetworkAvailable]) {
        return;
    }
    
    [self.bannerList removeAllObjects];
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_DISCOVERY;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(id resultObject) {
        NSDictionary *dict = resultObject;
        NSArray *bannerList = dict[@"bannerList"];
        
        if ([bannerList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemDict in bannerList) {
                BannerItemModel *model = [BannerItemModel yy_modelWithDictionary:itemDict];
                [self.bannerList addObject:model];
            }
            
            //  补齐collection中cell
            NSInteger m = [self.bannerList count] % 3;
            if (m) {
                NSInteger needAdd = 3 - m;
                for (NSInteger i = 0; i < needAdd; i++) {
                    BannerItemModel *model = [[BannerItemModel alloc] init];
                    [self.bannerList addObject:model];
                }
            }
            
            [self.collectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        CLog(@"%@",error);
    }];

}
#pragma mark -UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.bannerList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VHSDiscoverCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VHSDiscoverCell class]) forIndexPath:indexPath];
    cell.bannerItem = self.bannerList[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BannerItemModel *model = self.bannerList[indexPath.row];
    // discoveryType : 1 链接 2 电话
    if (model.discoveryType == 2) {
        //一键呼
        OnekeyCall *oner = [[OnekeyCall alloc] initWithPhone:model.hrefUrl];
        [oner call];
    }
    else if (model.hrefUrl) {
        PublicWKWebViewController *publicWebVC = [[PublicWKWebViewController alloc] init];
        publicWebVC.urlString = model.hrefUrl;
        publicWebVC.showTitle = YES;
        publicWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publicWebVC animated:YES];
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
