//
//  VHSBraceletCoodinator.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/23.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHSBraceletModel.h"


// 手环协调控制中心

@interface VHSBraceletCoodinator : NSObject

+ (instancetype)shareBraceletCoodinator;

/// 扫描外围手环设备
- (void)scanBraceletorDuration:(NSTimeInterval)time completion:(void (^)(NSArray<VHSBraceletModel *> *braceletorList))completionHandler;

/// 绑定手环
- (void)bindBraceletorCompletion:(void (^)(int code))completionHandler;
/// 解除绑定
- (void)unbindBraceletorCompletion:(void (^)(int code))completionHandler;

@end
