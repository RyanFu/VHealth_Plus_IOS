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

- (instancetype)initWithPhone:(NSString *)phone title:(NSString *)title content:(NSString *)content;

/// 检查更新
- (instancetype)initWithContent:(NSString *)content forceUpgrade:(BOOL)isForce downloadUrl:(NSString *)loadUrl;

/// 联系客服，一般的电话呼叫
- (instancetype)initWithNormalPhone:(NSString *)phone;

/// 弹出
- (void)call;

@end
