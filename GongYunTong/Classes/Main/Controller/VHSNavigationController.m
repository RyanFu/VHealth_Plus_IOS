//
//  VHSNavigationController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs. All rights reserved.
//

#import "VHSNavigationController.h"
#import "VHSTabConfigurationItem.h"

@interface VHSNavigationController ()

@property (nonatomic, strong) UIImageView *navImageView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSMutableArray *configNavTabList;

@end

@implementation VHSNavigationController

+ (void)initialize
{
    //设置searchBard的取消按钮颜色属性
    if (iOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
                                               setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],NSForegroundColorAttributeName,nil]
                                           forState:UIControlStateNormal];
    } else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
                             setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],NSForegroundColorAttributeName,nil]
                                           forState:UIControlStateNormal];
    }

//    // 设置整个项目所有item的主题样式
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    [item setStyle:UIBarButtonItemStylePlain];
//    // 设置导航栏返回按钮中的文字大小和颜色 key：NS****AttributeName
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    
//    // 设置不可用状态
//    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
//    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
//    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    

    // 设置高亮状态
    //    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionary];
    //    highTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    //    highTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    //    [item setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 隐藏/去掉 导航栏返回按钮中的文字
    //[item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    //自定义返回按钮
    //    UIImage *backButtonImage_OFF = [[UIImage imageNamed:@"navigationbar_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    //    [item setBackButtonBackgroundImage:backButtonImage_OFF forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // 设置返回按钮的样式
    UIBarButtonItem *baritem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [baritem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    //设置导航栏返回按钮箭头的颜色（若不实现setTitleTextAttributes: forState方法，可同时改变字体颜色)
    [navBar setTintColor:[UIColor blackColor]];
    //导航栏背景颜色
    [navBar setBarTintColor:[UIColor whiteColor]];
    //导航栏标题样式
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
}

//实现此方法，可在NavigationController的栈顶视图里设置信号栏字体颜色
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end
