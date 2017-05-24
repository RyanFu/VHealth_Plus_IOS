//
//  VHSDataBaseManager.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHSActionData.h"
#import <VeryfitSDK/FMDB.h>

@interface VHSDataBaseManager : NSObject

+ (VHSDataBaseManager *)shareInstance;          // 数据库管理员单例

/// 数据库路径
- (NSString *)dbPath;

/// 创建数据库
- (void)createDB;

/// 创建表
- (void)createTable;

/// 更新运动上传状态和公里数
- (void)updateActionUploadStatusWithMemberId:(NSString *)memberId;

////////////////

- (BOOL)insertNewAction:(VHSActionData *)action;

- (void)updateNewAction:(VHSActionData *)action;

- (NSInteger)rownumsWithAction:(VHSActionData *)action;

/// 查询数据库插入的最后一条数据
- (VHSActionData *)queryLatestActionWithMemberId:(NSString *)memberId mac:(NSString *)mac recordTime:(NSString *)recordTime;

- (VHSActionData *)queryLatestActionWithMemberId:(NSString *)memberId mac:(NSString *)mac recordTime:(NSString *)recordTime ctime:(NSString *)ctime;

/// 查寻未上传的数据和当前手环的数据
- (NSArray *)queryUnUploadActionListWithMemberId:(NSString *)memberId;

/// 获取一天的步数
- (NSArray *)queryOnedayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime;

/// 获取用户所有的数据
- (NSArray *)queryStepWithMemberId:(NSString *)memberId;

/// 更新旧手机数据为init_step数据
- (void)updateInitialStepWithOldAction:(VHSActionData *)oldAction;

/// 删除运动数据表数据
- (void)deleteAllAction;

/// 删除运动数据表
- (void)dropActionLstTable;

/// 删除15天以前的数据
- (void)deleteBeforeFifteenActionData;

@end
