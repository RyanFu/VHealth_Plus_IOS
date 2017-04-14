//
//  VHSBaseViewController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs. All rights reserved.
//

#import "VHSBaseViewController.h"

@interface VHSBaseViewController ()

@property (nonatomic, strong) UIImageView *navigationBar;

@end

@implementation VHSBaseViewController

- (UIImageView *)navigationBar {
    if (!_navigationBar) {
        CGFloat navH = ratioH * 44;
        
        UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, NAVIAGTION_HEIGHT - navH)];
        statusBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:statusBar];
        
        _navigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT - navH, SCREENW, navH)];
    }
    return _navigationBar;
}

-(void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLORHex(@"#efeff4");
    
    [k_NotificationCenter addObserver:self
                             selector:@selector(doubleClickTabbarItemAction)
                                 name:k_NOTI_DOUBLE_CLICK_TABBAR
                               object:nil];
    [k_NotificationCenter addObserver:self selector:@selector(downloanAdvertisingPage) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isVisible = YES;
    
    // 配置导航栏
    if ([self.navigationController.viewControllers count] > 1) {
        self.navigationController.navigationBarHidden = NO;
    }
    else if (self.tabConfigurationItem && [self.navigationController.viewControllers count] == 1 && [self.tabConfigurationItem.topType integerValue] == 0) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.isVisible = NO;
}

//设置状态栏中字体颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidde {
    return NO;
}

- (GlassView *)glassView {
    if (!_glassView) {
        _glassView = [[GlassView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH- 64)];
    }
    return _glassView;
}

-(void)setNextVcBackTitle:(NSString *)nextVcBackTitle {
    _nextVcBackTitle = nextVcBackTitle;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    item.title = nextVcBackTitle;
    self.navigationItem.backBarButtonItem = item;
}

#pragma mark -  配置导航栏

- (void)setTabConfigurationItem:(VHSTabConfigurationItem *)tabConfigurationItem {
    _tabConfigurationItem = tabConfigurationItem;
    
    // 0: 图片 1: 文字
    // 图片
    if (_tabConfigurationItem.topType.integerValue == 0) {
        self.navigationController.navigationBarHidden = YES;
        
        // 使用ImageView替代导航栏
        [self.view addSubview:self.navigationBar];
        [self.navigationBar sd_setImageWithURL:[NSURL URLWithString:_tabConfigurationItem.topUrl]];
    } else {
        self.navigationController.navigationBarHidden = NO;
        self.navigationItem.title = _tabConfigurationItem.topUrl;
    }
    
    // 配置TabbarItem
    self.tabBarItem.title = _tabConfigurationItem.footerName;
}

#pragma mark - 双击tabbar

- (void)doubleClickTabbarItemAction {
    
}

#pragma mark - 预缓存广告页

- (void)downloanAdvertisingPage {
    NSString *companyId = [[VHSCommon userInfo].companyId stringValue];
    if (!companyId) return;
    
    // 缓存缓存广告页
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_APP_START;
    message.httpMethod = VHSNetworkGET;
    message.timeout = 2.0;
    message.params = @{@"companyId" : companyId};
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        
        NSString *startUrl = result[@"startUrl"];
        NSInteger duration = [result[@"startTime"] integerValue];
        
        // 保存广告页的地址
        [VHSCommon saveLaunchUrl:startUrl];
        [VHSCommon saveLaunchDuration:duration];
        
        [VHSUtils saveImageWithPath:startUrl];
        
    } fail:^(NSError *error) {
        [VHSCommon setupRootController];
    }];
}

@end
