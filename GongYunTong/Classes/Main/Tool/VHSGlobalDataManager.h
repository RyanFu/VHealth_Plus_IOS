//
//  VHSGlobalDataManager.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/27.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MessageCounterType) {
    MessageCounterUrlType,
    MessageCounterTextType,
    MessageCounterClubType,
};

@interface VHSMessageCounter : NSObject

@property (assign, nonatomic) NSInteger messagePushUrlNumbers;      // 后台推送Url数量
@property (assign, nonatomic) NSInteger messagePushTextNumbers;     // 后台推送文本数量
@property (assign, nonatomic) NSInteger messagePushClubNumbers;     // 推送俱乐部数量

@property (assign, readonly, nonatomic) NSInteger messageAllNumbers;    // 所有的消息数量

- (void)increase:(MessageCounterType)type;  // 指定类型计数器增加1
- (void)decrease:(MessageCounterType)type;  // 指定类型计数器减少1

@end

@interface VHSGlobalDataManager : NSObject

@property (assign, nonatomic) NSInteger recordAllSteps;             // 记录的用户的所有步数
@property (assign, nonatomic) NSNumber *loadClubNumbers;            // 记录当前用户初始化融云次数
@property (strong, nonatomic) VHSMessageCounter *messageCounter;    // 消息推送计数对象

+ (VHSGlobalDataManager *)shareGlobalDataManager;

@end
