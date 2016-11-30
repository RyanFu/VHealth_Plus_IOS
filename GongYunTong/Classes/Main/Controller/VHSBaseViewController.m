//
//  VHSBaseViewController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs. All rights reserved.
//

#import "VHSBaseViewController.h"

@interface VHSBaseViewController ()

@end

@implementation VHSBaseViewController

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
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (GlassView *)glassView
{
    if (!_glassView)
    {
        _glassView = [[GlassView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH- 64)];
    }
    return _glassView;
}
-(void)setNextVcBackTitle:(NSString *)nextVcBackTitle {
    
    _nextVcBackTitle = nextVcBackTitle;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    item.title = nextVcBackTitle;
    self.navigationItem.backBarButtonItem = item;
}

@end
