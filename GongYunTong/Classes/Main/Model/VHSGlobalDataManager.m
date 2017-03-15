//
//  VHSGlobalDataManager.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/27.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSGlobalDataManager.h"

@implementation VHSGlobalDataManager

+ (VHSGlobalDataManager *)shareGlobalDataManager {
    static VHSGlobalDataManager *globalManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalManager = [[VHSGlobalDataManager alloc] init];
    });
    return globalManager;
}

@end
