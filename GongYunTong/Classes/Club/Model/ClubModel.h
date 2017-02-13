//
//  ClubModel.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubModel<ClubModelType> : NSObject

@property (nonatomic, strong) NSString *clubUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *members;
@property (nonatomic, assign) BOOL isRead;
/// 目标会话的ID，单聊为toUserId,讨论组为DiscusstionId
@property (nonatomic, strong) NSString *targetId;

- (instancetype)initWithIndex:(NSInteger)index;

@end
