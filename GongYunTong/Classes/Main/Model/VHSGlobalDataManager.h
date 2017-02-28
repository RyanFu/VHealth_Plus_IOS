//
//  VHSGlobalDataManager.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/27.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSGlobalDataManager : NSObject

@property (nonatomic, assign) NSInteger recordAllSteps;

+ (VHSGlobalDataManager *)shareGlobalDataManager;

@end
