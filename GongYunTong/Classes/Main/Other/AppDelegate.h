//
//  AppDelegate.h
//  GongYunTong
//
//  Created by vhsben on 16/7/15.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePeripheral.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *peripherals;


// 初始化外围设备
-(void)initConnectPeripheralSuccess:(void (^)())success;
// 同步手环数据
- (void)syncFitBleData:(void (^)(int errorCode))syncBlock;


/// 开启百度推送
- (void)startBaiDuPush:(UIApplication *)application launchingWithOptions:(NSDictionary *)launchOptions;

@end

