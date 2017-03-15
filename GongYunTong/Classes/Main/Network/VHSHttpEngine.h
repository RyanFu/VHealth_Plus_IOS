//
//  VHSHttpEngine.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHSRequestMessage.h"

//请求成功block
typedef void(^RequestSuccess)(NSDictionary *result);
//请求失败block
typedef void(^RequestFailure)(NSError *error);

@interface VHSHttpEngine : NSObject

+ (instancetype)sharedInstance;
// 发送请求
- (void)sendMessage:(VHSRequestMessage*)message success:(RequestSuccess)successBlock fail:(RequestFailure)failBlock;

@end
