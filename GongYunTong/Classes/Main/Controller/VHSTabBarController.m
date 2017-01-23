//
//  VHSTabBarController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSTabBarController.h"
#import "VHSNavigationController.h"
#import "TabbarItem.h"

typedef NS_ENUM(NSInteger, AcceptNotificationStatus)
{
    AcceptNotificationStatusOpen = 1,
    AcceptNotificationStatusClose
};

@interface VHSTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tabitemList;
@property (nonatomic, strong) UIImage *image;

@end

@implementation VHSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 服务器获取导航栏配置信息
    [self getTabNavConfiguration];
    
    [self addChildViewControllerWithStoryboard:@"Dynamic"
                          storyboardIdentifier:@"VHSDynamicHomeController"
                               tabBarItemTitle:@"动态"
                                         image:@"icon_dongtai"
                                andSelectImage:@"icon_dongtai_sel"];
    [self addChildViewControllerWithStoryboard:@"Activity"
                          storyboardIdentifier:@"VHSActivityController"
                               tabBarItemTitle:@"活动"
                                         image:@"icon_huodong"
                                andSelectImage:@"icon_huodong_sel"];
    [self addChildViewControllerWithStoryboard:@"Shop"
                          storyboardIdentifier:@"VHSShopController"
                               tabBarItemTitle:@"福利"
                                         image:@"icon_fuli"
                                andSelectImage:@"icon_fuli_selected"];
    [self addChildViewControllerWithStoryboard:@"Discover"
                          storyboardIdentifier:@"VHSDiscoverController"
                               tabBarItemTitle:@"发现"
                                         image:@"icon_faxian"
                                andSelectImage:@"icon_faxian_sel"];
    [self addChildViewControllerWithStoryboard:@"Me"
                          storyboardIdentifier:@"VHSMeController"
                               tabBarItemTitle:@"我"
                                         image:@"icon_wo"
                                andSelectImage:@"icon_wo_sel"];
    
    // 从缓存获取配置导航
    NSArray *listOfNavTab = [VHSCommon getUserDefautForKey:Cache_Config_NavOrTabbar];
    [self configNavOrTabWith:listOfNavTab];
    
    self.delegate = self;
    
    // 监听系统信息进入前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchOfNotification)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
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

- (void)addChildViewControllerWithStoryboard:(NSString *)sb
                        storyboardIdentifier:(NSString *)identifier
                             tabBarItemTitle:(NSString *)title
                                       image:(NSString *)imageName
                              andSelectImage:(NSString *)selectName {
    
    UIViewController *VC = [StoryboardHelper controllerWithStoryboardName:sb
                                                             controllerId:identifier];
    
    VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                  image:[[UIImage imageNamed:imageName]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                          selectedImage:[[UIImage imageNamed:selectName]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置字体
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}
                                             forState:UIControlStateNormal];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}
                                             forState:UIControlStateSelected];
    
    VHSNavigationController *navigationController = [[VHSNavigationController alloc] initWithRootViewController:VC];
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

/// 配置导航栏和Tabbar
- (void)getTabNavConfiguration {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_NAVIGATION;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(id response) {
        CLog(@"%@", response);
        
        NSDictionary *result = response;
        if ([result[@"result"] integerValue] != 200) return;
        
        NSArray *resultList = result[@"resultList"];
        [VHSCommon saveUserDefault:resultList forKey:Cache_Config_NavOrTabbar];
        
        // 配置导航栏和标签栏
        [self configNavOrTabWith:resultList];
        
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

/// 配置标签栏和导航栏
- (void)configNavOrTabWith:(NSArray *)dictList {
    
    if (![dictList isKindOfClass:[NSArray class]]) return;
    
    NSMutableArray *tabbarList = [NSMutableArray new];
    // 获取缓存数据源
    for (NSDictionary *dic in dictList) {
        TabbarItem *item = [TabbarItem yy_modelWithDictionary:dic];
        [tabbarList addObject:item];
    }
    
    // 根据后端返回的nindex去对应的改变controller
    [tabbarList enumerateObjectsUsingBlock:^(TabbarItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [item.nindex integerValue];
        
        VHSNavigationController *nav = (VHSNavigationController *)self.viewControllers[index - 1];
        VHSBaseViewController *baseVC = nav.viewControllers[0];
        baseVC.barItem = item;
    }];
}

/// 通知服务器，是否接受推送通知
- (void)postNotificationStatus:(AcceptNotificationStatus)status {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    if (status == AcceptNotificationStatusClose) {
        message.params = @{@"acceptMsg" : @"0"};
    } else {
        message.params = @{@"acceptMsg" : @"1"};
    }
    
    message.path = URL_UP_ACCEPT_MSG;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(id resultObject) {
        CLog(@"消息更改成功");
    } fail:^(NSError *error) {
        CLog(@"error == %@", error);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    static NSTimeInterval lastClickTime = 0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    if (currentTime - lastClickTime < 0.5) {
        [k_NotificationCenter postNotificationName:k_NOTI_DOUBLE_CLICK_TABBAR object:self];
    } else {
        lastClickTime = currentTime;
    }
}

@end
