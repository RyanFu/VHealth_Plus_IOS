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
    self.navigationController.navigationBarHidden = ![_tabConfigurationItem.topType boolValue];
    if ([_tabConfigurationItem.topType integerValue] == 0) {
        // 使用ImageView替代导航栏
        [self.view addSubview:self.navigationBar];
        [self.navigationBar sd_setImageWithURL:[NSURL URLWithString:_tabConfigurationItem.topUrl]];
        
    } else {
        self.navigationItem.title = _tabConfigurationItem.topUrl;
    }
    
    // 配置TabbarItem
    self.tabBarItem.title = _tabConfigurationItem.footerName;
}

@end
