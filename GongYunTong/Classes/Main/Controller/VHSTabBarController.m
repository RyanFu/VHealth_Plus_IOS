//
//  VHSTabBarController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSTabBarController.h"
#import "VHSNavigationController.h"

typedef NS_ENUM(NSInteger, AcceptNotificationStatus)
{
    AcceptNotificationStatusOpen = 1,
    AcceptNotificationStatusClose
};

@interface VHSTabBarController ()

@end

@implementation VHSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllerWithStoryboard:@"Dynamic" storyboardIdentifier:@"VHSDynamicHomeController" tabBarItemTitle:@"动态" image:@"icon_dongtai" andSelectImage:@"icon_dongtai_sel"];
    [self addChildViewControllerWithStoryboard:@"Activity" storyboardIdentifier:@"VHSActivityController" tabBarItemTitle:@"活动" image:@"icon_huodong" andSelectImage:@"icon_huodong_sel"];
    [self addChildViewControllerWithStoryboard:@"Shop" storyboardIdentifier:@"VHSShopController" tabBarItemTitle:@"福利" image:@"icon_fuli" andSelectImage:@"icon_fuli_selected"];
    [self addChildViewControllerWithStoryboard:@"Discover" storyboardIdentifier:@"VHSDiscoverController" tabBarItemTitle:@"发现" image:@"icon_faxian" andSelectImage:@"icon_faxian_sel"];
    
    [self addChildViewControllerWithStoryboard:@"Me" storyboardIdentifier:@"VHSMeController" tabBarItemTitle:@"我" image:@"icon_wo" andSelectImage:@"icon_wo_sel"];
    
    // 监听系统信息进入前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchOfNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}


/**
 *  为tabBar控制器添加子控制器
 *
 *  @param sb         控制器所在的故事板
 *  @param identifier 控制器在故事板的标识符
 *  @param title      tabBarItem上的标题
 *  @param imageName  tabBarItem上的默认图片
 *  @param selectName tabBarItem上的选中图片
 */

- (void)addChildViewControllerWithStoryboard:(NSString *)sb storyboardIdentifier:(NSString *)identifier tabBarItemTitle:(NSString *)title image:(NSString *)imageName andSelectImage:(NSString *)selectName {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sb bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置字体
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
//    viewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, -5, 0, 0);
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    VHSNavigationController *navigationController = [[VHSNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
    
}


#pragma mark - UIApplicationWillEnterForegroundNotification

- (void)switchOfNotification {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        // 通知开启状态
        [self postNotificationStatus:AcceptNotificationStatusOpen];
    } else {
        // 通知关闭状态
        [self postNotificationStatus:AcceptNotificationStatusClose];
    }
}

// 通知服务器，是否接受推送通知
- (void)postNotificationStatus:(AcceptNotificationStatus)status {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    if (status == AcceptNotificationStatusClose) {
        message.params = @{@"acceptMsg" : @"0"};
    } else {
        message.params = @{@"acceptMsg" : @"1"};
    }
    
    message.path = @"/upAcceptMsg.htm";
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(id resultObject) {
        NSLog(@"消息更改成功");
    } fail:^(NSError *error) {
        NSLog(@"error == %@", error);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

@end
