//
//  VHSDataBaseManager.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDataBaseManager.h"
#import "VHSCommon.h"
#import "VHSDefinition.h"
#import "VHSHeader.h"
#import "VHSDBSafetyCoordinator.h"

/// 手机计步：手机实时数据的回调是在子线程中的，查询数据是在主现场中的，为了避免主线程和子线程同时争抢BD对象，所以每一次数据操作都创建一个新的DB对象

@interface VHSDataBaseManager ()

@end

// action_type 定义当前纪录步数类型

@implementation VHSDataBaseManager

+ (VHSDataBaseManager *)shareInstance {
    static VHSDataBaseManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSString *)dbPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths lastObject];
    return [documentsDir stringByAppendingPathComponent:@"HealthRunUser.db"];
}

// 用户数据库创建处理
- (void)createDB {
    // 覆盖安装前低于当前版本，修改表结构
    float appVersion = [[VHSCommon getUserDefautForKey:k_APPVERSION] floatValue];
    
    if (appVersion < [[VHSCommon appVersion] floatValue]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self dbPath]]) {
            [self dropActionLstTable];
        }
        [self createTable];
        [self alterActionLstTable];
    } else if (![[NSFileManager defaultManager] fileExistsAtPath:[self dbPath]]) {
        [self createTable];
        [self alterActionLstTable];
    }
    
    // 清空15天以前的数据
    [self deleteBeforeFifteenActionData];
}

- (FMDatabase *)getFmdb {
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    return db;
}

- (void)createTable {
    
    FMDatabase *db = [self getFmdb];
    [db open];
    //  创建 运动信息一览表
    NSString *createSportTableSql = @"CREATE TABLE IF NOT EXISTS 'action_lst' \
    (   'action_id'             VARCHAR(36), \
        'member_id'             VARCHAR(36),\
        'action_mode'           VARCHAR(8),\
        'action_type'           VARCHAR(8),\
        'distance'              VARCHAR(36),\
        'seconds'               VARCHAR(36),\
        'calorie'               VARCHAR(36),\
        'step'                  VARCHAR(36),\
        'start_time'            VARCHAR(36),\
        'end_time'              VARCHAR(36),\
        'record_time'           VARCHAR(36),\
        'score'                 VARCHAR(36),\
        'upload'                INTEGER,\
        'mac_address'           VARCHAR(36)\
    )";
    
    BOOL flag = [db executeUpdate:createSportTableSql];
    
    if (flag) {
        CLog(@"创建－－－运动信息一览表－－－成功");
    } else {
        CLog(@"创建－－－运动信息一览表－－－失败");
    }
    
    [db close];
}

// 更新用户运动信息的上传状态
- (void)updateActionStatus:(NSString *)recordTime mac:(NSString *)mac distance:(NSString *)distance {
    if ([VHSCommon isNullString:recordTime] || [VHSCommon isNullString:mac]) return;
    
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    NSString *encryRecordTime = [safety encryptRecordTime:recordTime];
    
    NSString *sql = @"UPDATE action_lst SET upload = 1, distance = '%@'  where record_time = '%@' and mac_address = '%@';";
    NSString *updateStatusSql = [NSString stringWithFormat:sql, distance, encryRecordTime, mac];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    [db executeUpdate:updateStatusSql];
    [db close];
}

//////// 新的查询存储模块

- (BOOL)insertNewAction:(VHSActionData *)action {
    
    if (!action.actionId.length || !action.actionId) {
        return NO;
    } else if (!action.memberId.length || !action.memberId) {
        return NO;
    } else if ([VHSCommon isNullString:action.macAddress] || [action.macAddress containsString:@"null"]) {
        return NO;
    }
    
    BOOL flag = NO;
    
    // 对数据加密
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    VHSActionData *encryAction = [safety encryptAction:action];
    
    // 获取DB对象
    FMDatabase *db = [self getFmdb];
    [db open];
    
    NSString *insertSql = @"INSERT INTO action_lst (action_id, member_id, action_mode, action_type, distance, seconds, calorie, step, start_time, end_time, record_time, score, upload, mac_address, init_step, current_device_step) VALUES (? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
    flag = [db executeUpdate:insertSql,
            encryAction.actionId,
            encryAction.memberId,
            encryAction.actionMode,
            encryAction.actionType,
            encryAction.distance,
            encryAction.seconds,
            encryAction.calorie,
            encryAction.step,
            encryAction.startTime,
            encryAction.endTime,
            encryAction.recordTime,
            encryAction.score,
            @(encryAction.upload),
            encryAction.macAddress,
            encryAction.initialStep,
            encryAction.currentDeviceStep];
    
    [db close];
    
    return flag;
}

- (void)updateNewAction:(VHSActionData *)action {
    if (!action.memberId || !action.recordTime || !action.actionType || [VHSCommon isNullString:action.macAddress] || [action.macAddress containsString:@"null"]) return;
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    VHSActionData *encryAction = [safety encryptAction:action];
    
    // 查询最新的一条数据
    VHSActionData *oldActionData = [self queryLatestActionWithMemberId:action.memberId mac:action.macAddress recordTime:action.recordTime];
    
    // 更新运动数据
    if (oldActionData) {

        NSInteger validStep = 0;
        if (![oldActionData.macAddress isEqualToString:@"0"]) {
            // 手环更新
            validStep = action.step.integerValue - oldActionData.initialStep.integerValue;
            // 更新数据防止误会出错判断，1. 第一次手环摇动步数低于35不计算 2. 要更新的有效步数低于数据库原来存储的的步数，不更新
            if (validStep < 35 || validStep < oldActionData.step.integerValue) {
                return;
            }
        } else {
            // 手机步数更新
            validStep = action.step.integerValue;
            // 更新数据小于原来的数据，则不更新
            if (validStep <= oldActionData.step.integerValue) {
                return;
            }
        }
        
        NSString *sql = @"update action_lst set step='%@', upload=0, current_device_step='%@' where action_id='%@';";
        
        NSString *encryStep = [safety encryptStep:@(validStep).stringValue];
        NSString *updateSql = [NSString stringWithFormat:sql, encryStep, action.currentDeviceStep, oldActionData.actionId];
        [db executeUpdate:updateSql];
        
        // 更新当天相同mac地址的数据为未上传
        if (![oldActionData.macAddress isEqualToString:@"0"]) {
            NSString *unloadSql = @"update action_lst set upload=0 where member_id='%@' and record_time='%@' and mac_address='%@';";
            NSString *updateUnloadSql = [NSString stringWithFormat:unloadSql, encryAction.memberId, encryAction.recordTime, encryAction.macAddress];
            [db executeUpdate:updateUnloadSql];
        }
        
        [db close];
        
        return;
    }
    
    // 跨天
    action.initialStep = @"0";
    [self insertNewAction:action];
}

- (NSInteger)rownumsWithAction:(VHSActionData *)action {
    NSString *sql = @"select count() as rownums from action_lst \
    where \
    member_id = '%@' and action_type = '%@' and record_time = '%@' ";
    
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    VHSActionData *encryAction = [safety encryptAction:action];
    
    if (![VHSCommon isNullString:encryAction.macAddress]) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and mac_address = '%@' ", action.macAddress]];
    }
    sql = [sql stringByAppendingString:@";"];
    
    NSString *selSql = [NSString stringWithFormat:sql, encryAction.memberId, encryAction.actionType, encryAction.recordTime];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    FMResultSet *rs = [db executeQuery:selSql];
    
    NSInteger rowNums = 0;
    while ([rs next]) {
        rowNums = [rs intForColumn:@"rownums"];
    }
    [db close];
    
    return rowNums;
}

- (NSArray *)queryOnedayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime {
    NSArray *onedayStep = [self selectListWithMemberId:memberId recordTime:recordTime actionType:nil upload:nil macAddress:nil];
    return onedayStep;
}

- (NSArray *)queryStepWithMemberId:(NSString *)memberId {
    NSArray *actionList = [self selectListWithMemberId:memberId recordTime:nil actionType:nil upload:nil macAddress:nil];
    return actionList;
}

- (NSArray *)oneUserActionListWithMemberId:(NSString *)memberId upload:(NSString *)isUpload {
    NSArray *actionList = [self selectListWithMemberId:memberId recordTime:nil actionType:nil upload:isUpload macAddress:nil];
    return actionList;
}

- (NSArray *)queryUnUploadActionListWithMemberId:(NSString *)memberId {
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    NSString *encryptMemberId = [safety encryptMemberId:memberId];
    
    NSString *sql = @"select * from action_lst where member_id='%@' and upload=0;";
    
    NSString *querySql = [NSString stringWithFormat:sql, encryptMemberId];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    FMResultSet *rs = [db executeQuery:querySql];
    NSArray *actionList = [self queryActionListWithFMResultSet:rs];
    
    // 获取手机没有上传当天的数据
    NSMutableArray *actionResultList = [NSMutableArray new];
    
    NSMutableArray *recordTimeList = [NSMutableArray new];
    for (VHSActionData *action in actionList) {
        if ([action.macAddress isEqualToString:@"0"]) {
            if (![recordTimeList containsObject:action.recordTime]) {
                [recordTimeList addObject:action.recordTime];
            }
        } else {
            [actionResultList addObject:action];
        }
    }
    
    NSString *mobileSql = @"select * from action_lst where member_id='%@' and record_time='%@' and mac_address='0';";
    for (NSString *recordTime in recordTimeList) {
        
        NSString *encryRecordTime = [safety encryptRecordTime:recordTime];
        
        NSString *getRecordSql = [NSString stringWithFormat:mobileSql, encryptMemberId, encryRecordTime];
        
        FMResultSet *result = [db executeQuery:getRecordSql];
        NSArray *actionList = [self queryActionListWithFMResultSet:result];
        
        VHSActionData *ac = [actionList firstObject];
        NSInteger mobileStep = 0;
        for (VHSActionData *aa in actionList) {
            mobileStep += aa.step.integerValue;
        }
        ac.step = @(mobileStep).stringValue;
        
        [actionResultList addObject:ac];
    }
    
    
    [db close];
    
    return actionResultList;
}

- (NSArray *)selectListWithMemberId:(NSString *)memberId
                         recordTime:(NSString *)recordTime
                         actionType:(NSString *)actionType
                             upload:(NSString *)upload
                         macAddress:(NSString *)macAddress {
    if (!memberId) return @[];
    
    NSString *sql = @"select * from action_lst where ";
    
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    
    if (memberId) {
        NSString *encryMemberId = [safety encryptMemberId:memberId];
        
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" member_id = '%@' ", encryMemberId]];
    }
    if (recordTime) {
        NSString *encryRecordTime = [safety encryptMemberId:recordTime];
        
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and record_time = '%@' ", encryRecordTime]];
    }
    if (actionType) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and action_type = '%@' ", actionType]];
    }
    if (upload) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and upload = %@ ", upload]];
    }
    if (macAddress) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and mac_address = '%@' ", macAddress]];
    }
    
    sql = [sql stringByAppendingString:@";"];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    FMResultSet *rs = [db executeQuery:sql];
    NSArray *actionList = [self queryActionListWithFMResultSet:rs];
    
    return actionList;
}

- (VHSActionData *)queryLatestActionWithMemberId:(NSString *)memberId mac:(NSString *)mac recordTime:(NSString *)recordTime ctime:(NSString *)ctime {
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    
    NSString *encryptMemberId = [safety encryptMemberId:memberId];
    NSString *encryptRecordTime = [safety encryptRecordTime:recordTime];
    
    NSString *sql = @"select * from action_lst where member_id = '%@' and mac_address = '%@' and record_time = '%@' order by start_time desc limit 1 offset 0;";
    NSString *querySql = [NSString stringWithFormat:sql, encryptMemberId, mac, encryptRecordTime];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:querySql];
    NSArray *actionList = [self queryActionListWithFMResultSet:resultSet];
    
    VHSActionData *action = [actionList firstObject];
    
    return action;
}

- (VHSActionData *)queryLatestActionWithMemberId:(NSString *)memberId mac:(NSString *)mac recordTime:(NSString *)recordTime {
    return [self queryLatestActionWithMemberId:memberId mac:mac recordTime:recordTime ctime:nil];
}

- (NSArray *)queryActionListWithFMResultSet:(FMResultSet *)resultSet {
    
    VHSDBSafetyCoordinator *safety = [VHSDBSafetyCoordinator shareDBCoordinator];
    
    NSMutableArray *actionList = [NSMutableArray array];
    
    while ([resultSet next]) {
        NSString *action_id = [resultSet stringForColumn:@"action_id"];
        NSString *member_id = [resultSet stringForColumn:@"member_id"];
        NSString *action_type = [resultSet stringForColumn:@"action_type"];
        NSString *distance = [resultSet stringForColumn:@"distance"];
        NSString *calorie = [resultSet stringForColumn:@"calorie"];
        NSString *step = [resultSet stringForColumn:@"step"];
        NSString *start_time = [resultSet stringForColumn:@"start_time"];
        NSString *end_time = [resultSet stringForColumn:@"end_time"];
        NSString *record_time = [resultSet stringForColumn:@"record_time"];;
        NSString *score = [resultSet stringForColumn:@"score"];
        NSInteger upload = [resultSet intForColumn:@"upload"];
        NSString *mac_address = [resultSet stringForColumn:@"mac_address"];
        NSString *initialStep = [resultSet stringForColumn:@"init_step"];
        NSString *currentDeviceStep = [resultSet stringForColumn:@"current_device_step"];
        if (!mac_address) mac_address = @"";
        
        VHSActionData *action = [[VHSActionData alloc] init];
        action.actionId = action_id;
        action.memberId = member_id;
        action.actionType = action_type;
        action.distance = distance;
        action.calorie = calorie;
        action.step = step;
        action.startTime = start_time;
        action.endTime = end_time;
        action.recordTime = record_time;
        action.score = score;
        action.upload = upload;
        action.macAddress = mac_address;
        action.initialStep = initialStep;
        action.currentDeviceStep = currentDeviceStep;
        
        VHSActionData *decryptAction = [safety decryptAction:action];
        
        [actionList addObject:decryptAction];
    }
    
    return [actionList copy];
}

- (void)updateInitialStepWithOldAction:(VHSActionData *)oldAction {
    // 更新旧数据为当前新数据的初始值
    if (oldAction) {
        NSString *sql = @"update action_lst set  init_step='%@', upload=0 where action_id='%@';";
        
        NSString *validStep = @(oldAction.step.integerValue + oldAction.initialStep.integerValue).stringValue;
        NSString *mobileUpdateSql = [NSString stringWithFormat:sql, validStep, oldAction.actionId];
        
        FMDatabase *db = [self getFmdb];
        [db open];
        
        [db executeUpdate:mobileUpdateSql];
        [db close];
    }
}

- (void)deleteAllAction {
    NSString *deleteSql = @"DELETE FROM action_lst;";
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    [db executeUpdate:deleteSql];
    [db close];
}

- (void)dropActionLstTable {
    NSString *dropSql = @"drop table action_lst;";
    
    FMDatabase *db = [self getFmdb];
    [db open];
    [db executeUpdate:dropSql];
    [db close];
}

// 修改表结构
- (void)alterActionLstTable {
    // 修改表结构
    NSString *alterSqlAddInitStep = @"ALTER TABLE action_lst ADD init_step VARCHAR(36);";
    NSString *alterSqlCurrentDeviceStep = @"ALTER TABLE action_lst ADD current_device_step VARCHAR(36);";
    
    FMDatabase *db = [self getFmdb];
    [db open];
    [db executeUpdate:alterSqlAddInitStep];
    [db executeUpdate:alterSqlCurrentDeviceStep];
    [db close];
}

- (void)deleteBeforeFifteenActionData {
    NSString *sql = @"delete from action_lst where start_time < '%@';";
    
    NSString *deleteSql = [NSString stringWithFormat:sql, [VHSCommon getBeforeFifteenDay]];
    FMDatabase *db = [self getFmdb];
    [db open];
    [db executeUpdate:deleteSql];
    [db close];
}

@end
