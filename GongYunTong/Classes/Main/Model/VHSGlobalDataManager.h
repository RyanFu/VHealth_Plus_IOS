//
//  VHSGlobalDataManager.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/27.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSGlobalDataManager : NSObject

@property (nonatomic, assign) NSInteger recordAllSteps;     // 记录的用户的所有步数

@property (nonatomic, assign) NSNumber *loadClubNumbers;       // 记录当前用户初始化融云次数

+ (VHSGlobalDataManager *)shareGlobalDataManager;

@end
