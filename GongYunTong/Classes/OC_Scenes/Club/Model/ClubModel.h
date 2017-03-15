//
//  ClubModel.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubModel<ClubModelType> : NSObject

@property (nonatomic, strong) NSString *clubId;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *clubName;
@property (nonatomic, strong) NSString *slogan;
@property (nonatomic, strong) NSString *memberCount;
@property (nonatomic, assign) BOOL newMsg;
@property (nonatomic, strong) NSString *memberType; // 1: 管理员 2: 成员 0: 未加入
@property (nonatomic, strong) NSString *clubUrl;

/// 目标会话的ID，单聊为toUserId,讨论组为DiscusstionId
@property (nonatomic, strong) NSString *rongGroupId;

/// 用于控制试图列表
@property (assign, nonatomic) BOOL haveFooter;

@end
