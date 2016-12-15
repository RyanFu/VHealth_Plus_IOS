//
//  OnekeyCall.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/10.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneAlertCaller : NSObject

/// 一键呼
- (instancetype)initWithPhone:(NSString *)phone;
- (void)call;

// 检查更新
- (instancetype)initWithContent:(NSString *)content forceUpgrade:(BOOL)isForce;

@end
