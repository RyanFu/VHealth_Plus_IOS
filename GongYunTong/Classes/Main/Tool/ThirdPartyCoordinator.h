//
//  ThirdPartyCoordinator.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/22.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdPartyCoordinator : NSObject

/// 第三方框架管理协调器
+ (ThirdPartyCoordinator *)shareCoordinator;

/// 启动百度移动统计
- (void)startBaiduMobileStat;

/// 百度推送
- (void)startBaiDuPush:(UIApplication *)application launchingWithOptions:(NSDictionary *)launchOptions;

/// 融云
- (void)setupRCKit;

@end
