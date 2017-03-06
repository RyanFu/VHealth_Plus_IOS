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

/// 更新运动上传状态
-(void)updateStatusToActionLst:(NSString *)recordTime macAddress:(NSString *)macAddress distance:(NSString *)distance;

////////////////

- (BOOL)insertNewAction:(VHSActionData *)action;

- (void)updateNewAction:(VHSActionData *)action;

- (NSInteger)rownumsWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType;

- (NSString *)dbStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType;

- (VHSActionData *)actionWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType;

- (NSArray *)onedayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime;

- (NSArray *)oneUserActionWithMemberId:(NSString *)memberId actionType:(NSString *)actionType;

- (NSArray *)oneUserActionListWithMemberId:(NSString *)memberId upload:(NSString *)isUpload;

#pragma mark - 定时任务数据表处理

- (void)createTimingTaskTable;
- (void)insertTimingTaskWith:(VHSActionData *)action;

@end
