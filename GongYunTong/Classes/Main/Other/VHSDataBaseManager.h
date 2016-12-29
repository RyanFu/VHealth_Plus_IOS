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

/// 获取未上传所有运动（运动一览表）
//-(NSMutableArray *)selectUnuploadFromActionLst:(NSString *)memberId;

/// 获取用户一天的总步数
//- (NSInteger)selectSumDayStepsFromActionLst:(NSString *)memberId ymd:(NSString *)ymd;

/// 更新，同步Ble手环数据
//- (void)insertOrUpdateBleAction:(VHSActionData *)action;

/// 更新，同步HealthKit处理器数据
//- (void)insertOrUpdateM7Action:(VHSActionData *)action;

/// 更新运动数据
//- (void)updateSportStepWithActionData:(VHSActionData *)action;

/// 判断某用户指定时间对应的运动类型是否存在数据
//- (BOOL)isExistActionWithMemberId:(NSString *)memberId actionType:(NSString *)actionType recordTime:(NSString *)recordTime;
/// 获取某用户指定时间对应的运动类型是否存在数据
//- (NSInteger)dbStepWithMemberId:(NSString *)memberId actionType:(NSString *)actionType recordTime:(NSString *)recordTime;


////////////////

- (BOOL)insertNewAction:(VHSActionData *)action;

- (void)updateNewAction:(VHSActionData *)action;

- (NSInteger)rownumsWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType;

- (NSString *)dbStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType;

- (VHSActionData *)actionWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType;

- (NSArray *)onedayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime;

- (NSArray *)oneUserActionWithMemberId:(NSString *)memberId actionType:(NSString *)actionType;

- (NSArray *)oneUserActionListWithMemberId:(NSString *)memberId upload:(NSString *)isUpload;


@end
