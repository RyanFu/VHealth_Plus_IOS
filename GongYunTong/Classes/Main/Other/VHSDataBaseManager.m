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
#import "VHS_Header.h"
#import "NSString+AES256.h"

/// 手机计步：手机实时数据的回调是在子线程中的，查询数据是在主现场中的，为了避免主线程和子线程同时争抢BD对象，所以每一次数据操作都创建一个新的DB对象

//#define KEY_OF_AES       @"123456"

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
    // 用户数据库不存在时，新建
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dbPath]]) {
        [VHSCommon saveDataBaseVersion];
    } else {
        NSInteger version = [VHSCommon getDatabaseVersion];
        // 当前数据库版本和定义的数据库版本不一致
        if (version != k_VHS_DataBase_Version) {}
    }
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

- (BOOL)insertAction:(VHSActionData *)action {
    
//    if (!action.actionId.length || !action.actionId) {
//        return NO;
//    }
//    else if (!action.memberId.length || !action.memberId) {
//        return NO;
//    }
//    
//    BOOL flag = NO;
//    
//    // 获取DB对象
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    NSString *insertSql = @"INSERT INTO action_lst (action_id, member_id, action_mode, action_type, distance, seconds, calorie, step, start_time, end_time, record_time, score, upload, mac_address) VALUES (? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
//    
//    NSString *ecStep = [action.step aes256_encrypt:KEY_OF_AES];
//    action.memberId = [action.memberId aes256_encrypt:KEY_OF_AES];
//    action.recordTime = [action.recordTime aes256_encrypt:KEY_OF_AES];
//    
//    flag = [db executeUpdate:insertSql,
//            action.actionId,
//            action.memberId,
//            action.actionMode,
//            action.actionType,
//            action.distance,
//            action.seconds,
//            action.calorie,
//            ecStep,
//            action.startTime,
//            action.endTime,
//            action.recordTime,
//            action.score,
//            @(action.upload),
//            action.macAddress];
//    
//    if (flag) {
//        CLog(@"插入一条数据成功");
//    } else {
//        CLog(@"插入一条数据失败");
//    }
//    
//    [db close];
//    
//    return flag;
    return YES;
}

- (BOOL)isExistActionWithMemberId:(NSString *)memberId actionType:(NSString *)actionType recordTime:(NSString *)recordTime {
//    if (!memberId || !actionType.length || !recordTime.length) return NO;
//    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    NSString *sql = [NSString stringWithFormat:@"select count(action_id) as nums from action_lst where member_id = '%@' and record_time = '%@' and action_type = '%@';", memberId, recordTime, actionType];
//    FMResultSet *rs = [db executeQuery:sql];
//    
//    NSInteger nums = 0;
//    while ([rs next]) {
//        nums = [rs intForColumn:@"nums"];
//    }
//    [db close];
//    
//    if (nums > 0) {
//        return YES;
//    } else {
//        return NO;
//    }
    return YES;
}

- (NSInteger)dbStepWithMemberId:(NSString *)memberId actionType:(NSString *)actionType recordTime:(NSString *)recordTime {
//    if (!memberId || !actionType.length || !recordTime.length) return 0;
//    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    NSString *sql = [NSString stringWithFormat:@"select step from action_lst where member_id = '%@' and record_time = '%@' and action_type = '%@';", memberId, recordTime, actionType];
//    FMResultSet *rs = [db executeQuery:sql];
//    
//    NSInteger step = 0;
//    while ([rs next]) {
//        step = [[[rs stringForColumn:@"step"] aes256_decrypt:KEY_OF_AES] integerValue];
//    }
//    [db close];
//    
//    return step;
    return 10;
}

- (void)insertOrUpdateM7Action:(VHSActionData *)action {
    
//    action.memberId = [action.memberId aes256_encrypt:KEY_OF_AES];
//    NSString *enRecordTime = [action.recordTime aes256_encrypt:KEY_OF_AES];
//    
//    BOOL flag = [self isExistActionWithMemberId:action.memberId actionType:action.actionType recordTime:enRecordTime];
//    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    if (flag) {
//        NSInteger dbStep = [self dbStepWithMemberId:action.memberId actionType:action.actionType recordTime:enRecordTime];
//        // 更新
//        NSString *destSteps = [@(dbStep + [action.step integerValue]) stringValue];
//        NSString *updateSql = [NSString stringWithFormat:@"update action_lst set step = '%@', upload = 0, end_time = '%@' where record_time = '%@' and action_type = %@  and member_id = '%@'", [destSteps aes256_encrypt:KEY_OF_AES], action.endTime, enRecordTime, action.actionType, action.memberId];
//        
//        [db executeUpdate:updateSql];
//        
//        CLog(@"更新一条数据成功－－－－－success");
//    } else {
//        // 插入
//        action.startTime = [VHSCommon getDate:[NSDate date]];
//        action.endTime = [VHSCommon getDate:[NSDate date]];
//        action.recordTime = enRecordTime;
//        action.step = [action.step aes256_encrypt:KEY_OF_AES];
//        [self insertAction:action];
//        
//        CLog(@"插入一条数据成功－－－－－success");
//    }
//    
//    [db close];
}

// 更新用户运动信息的上传状态
-(void)updateStatusToActionLst:(NSString *)recordTime macAddress:(NSString *)macAddress distance:(NSString *)distance {
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE action_lst SET upload = 1, distance = %@  where record_time = '%@' and mac_address = '%@'", distance, recordTime, macAddress];
    
    BOOL res = [db executeUpdate:sql];
    if (res) {
        DLog(@"更新－－－运动信息一览表－－－状态－－－成功");
    } else {
        DLog(@"更新－－－运动信息一览表－－－状态－－－失败");
    }
    
    [db close];
}

// 获取用户没有上传的运动信息 
- (NSMutableArray *)selectUnuploadFromActionLst:(NSString *)memberId {
//    NSMutableArray *unUploadList = [NSMutableArray new];
//    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    memberId = [memberId aes256_encrypt:KEY_OF_AES];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM action_lst WHERE member_id = '%@' AND upload = 0 ORDER BY action_id desc", memberId];
//    
//    FMResultSet *rs = [db executeQuery:sql];
//    while ([rs next]) {
//        NSString *action_id = [rs stringForColumn:@"action_id"];
//        NSString *member_id = [[rs stringForColumn:@"member_id"] aes256_decrypt:KEY_OF_AES];
//        NSString *action_type = [rs stringForColumn:@"action_type"];
//        NSString *distance = [rs stringForColumn:@"distance"];
//        NSString *calorie = [rs stringForColumn:@"calorie"];
//        NSString *step = [[rs stringForColumn:@"step"] aes256_decrypt:KEY_OF_AES];
//        NSString *start_time = [rs stringForColumn:@"start_time"];
//        NSString *end_time = [rs stringForColumn:@"end_time"];
//        NSString *record_time = [[rs stringForColumn:@"record_time"] aes256_decrypt:KEY_OF_AES];;
//        NSString *score = [rs stringForColumn:@"score"];
//        NSInteger upload = [rs intForColumn:@"upload"];
//        NSString *mac_address = [rs stringForColumn:@"mac_address"];
//        
//        VHSActionData *action = [[VHSActionData alloc] init];
//        action.actionId = action_id;
//        action.memberId = member_id;
//        action.actionType = action_type;
//        action.distance = distance;
//        action.calorie = calorie;
//        action.step = step;
//        action.startTime = start_time;
//        action.endTime = end_time;
//        action.recordTime = record_time;
//        action.score = score;
//        action.upload = upload;
//        action.macAddress = mac_address;
//        
//        [unUploadList addObject:action];
//    }
//        
//    [db close];
//    
//    return unUploadList;
    return [@[] mutableCopy];
}

- (NSInteger)selectSumDayStepsFromActionLst:(NSString *)memberId ymd:(NSString *)recordTime {
//    NSInteger sum = 0;
//    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    memberId = [memberId aes256_encrypt:KEY_OF_AES];
//    recordTime = [recordTime aes256_encrypt:KEY_OF_AES];
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT step FROM action_lst WHERE member_id = '%@' AND record_time = '%@'", memberId, recordTime];
//    FMResultSet *rs = [db executeQuery:sql];
//    
//    while ([rs next]) {
//        sum += [[[rs stringForColumn:@"step"] aes256_decrypt:KEY_OF_AES] integerValue];
//    }
//    
//    [db close];
//    
//    return sum;
    return 10;
}

- (void)insertOrUpdateBleAction:(VHSActionData *)action {
    
//    BOOL flag = [self isExistActionWithMemberId:action.memberId
//                                        actionType:action.actionType
//                                        recordTime:action.recordTime];
//    
//    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//
//    
//    if (flag) {
//        NSInteger dbStep = [self dbStepWithMemberId:action.memberId actionType:action.actionType recordTime:action.recordTime];
//        
//        // 存在该数据 －－ 更新
//        NSString *destSteps = [@([action.step integerValue] + dbStep) stringValue];
//        destSteps = [destSteps aes256_encrypt:KEY_OF_AES];
//        NSString *updateSql = [NSString stringWithFormat:@"update action_lst set step = '%@', upload = 0, end_time = '%@' where record_time = '%@' and action_type = %@ and member_id = '%@'", destSteps, [VHSCommon getDate:[NSDate date]], action.recordTime, action.actionType, action.memberId];
//        BOOL res = [db executeUpdate:updateSql];
//        if (res) CLog(@"更新一条数据成功－－－－－success");
//    }
//    else {
//        // 不存在该数据 －－ 插入
//        action.memberId = [VHSCommon userInfo].memberId.stringValue;
//        action.distance = @"0.0";
//        action.seconds = @"0.0";
//        action.calorie = @"0.0";
//        action.startTime = [VHSCommon getDate:[NSDate date]];
//        action.endTime = [VHSCommon getDate:[NSDate date]];
//        action.score = @"0";
//        action.upload = 0;
//        action.macAddress = [VHSCommon getShouHuanMacSddress];
//        
//        BOOL res = [self insertAction:action];
//        if (res)  CLog(@"插入一条数据成功－－－－－success");
//    }
//    [db close];
}

/// 更新数据库中的数据
- (void)updateSportStepWithActionData:(VHSActionData *)action {
    
//    FMDatabase *db = [self getFmdb];
//    [db open];
//    
//    NSString *enMemberId = [action.memberId aes256_encrypt:KEY_OF_AES];
//    NSString *enRecordTime = [action.recordTime aes256_encrypt:KEY_OF_AES];
//    
//    BOOL exsit = [self isExistActionWithMemberId:enMemberId actionType:action.actionType recordTime:enRecordTime];
//    
////    NSString *sql = [NSString stringWithFormat:@"select action_id, step from action_lst where record_time = '%@' and action_type = '%@' and member_id = '%@'", enRecordTime, action.actionType, enMemberId];
////    FMResultSet *rs = [db executeQuery:sql];
////    BOOL exsit = NO;
////    NSString *actionId = nil;
////    NSInteger step = 0;
////    while ([rs next]) {
////        actionId = [rs stringForColumn:@"action_id"];
////        step = [[[rs stringForColumn:@"step"] aes256_decrypt:KEY_OF_AES] integerValue];
////        if (actionId) {
////            exsit = YES;
////        }
////    }
//    
//    // 更新
//    if (exsit) {
//        NSInteger dbStep = [self dbStepWithMemberId:enMemberId actionType:action.actionType recordTime:enRecordTime];
//        // 只有当云端数据大于本地数据是更新
//        if ([action.step integerValue] > dbStep) {
//            NSString *sql = [NSString stringWithFormat:@"update action_lst set step = '%@', distance = %@ where mac_address = '%@' and member_id = '%@' and record_time = '%@'", [action.step aes256_encrypt:KEY_OF_AES], action.distance, action.macAddress, enMemberId, enRecordTime];
//            [db executeUpdate:sql];
//        }
//    } else {
//        action.actionId = [VHSCommon getTimeStamp];
//        action.actionMode = @"0";
//        action.seconds = @"0.0";
//        action.calorie = @"0.0";
//        action.startTime = [VHSCommon getDate:[NSDate date]];
//        action.endTime = [VHSCommon getDate:[NSDate date]];
//        action.score = @"0";
//        
//        [self insertAction:action];
//    }
//    
//    [db close];
}


//////// 新的查询存储模块

- (BOOL)insertNewAction:(VHSActionData *)action {
    
        if (!action.actionId.length || !action.actionId) {
            return NO;
        }
        else if (!action.memberId.length || !action.memberId) {
            return NO;
        }
    
        BOOL flag = NO;
    
        // 获取DB对象
        FMDatabase *db = [self getFmdb];
        [db open];
    
        NSString *insertSql = @"INSERT INTO action_lst (action_id, member_id, action_mode, action_type, distance, seconds, calorie, step, start_time, end_time, record_time, score, upload, mac_address) VALUES (? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
        flag = [db executeUpdate:insertSql,
                action.actionId,
                action.memberId,
                action.actionMode,
                action.actionType,
                action.distance,
                action.seconds,
                action.calorie,
                action.step,
                action.startTime,
                action.endTime,
                action.recordTime,
                action.score,
                @(action.upload),
                action.macAddress];
        
        [db close];
        
    return flag;
}

- (void)updateNewAction:(VHSActionData *)action {
    if (!action.memberId || !action.recordTime || !action.actionType) return;
    
    NSString *sql = @"update action_lst \
    set \
    step = '%@', upload = 0, end_time = '%@', mac_address = '%@' \
    where \
    record_time = '%@' and action_type = %@  and member_id = '%@'";
    
    NSString *updateSql = [NSString stringWithFormat:sql, action.step, action.endTime, action.macAddress, action.recordTime, action.actionType, action.memberId];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    [db executeUpdate:updateSql];
    [db close];
}

- (NSInteger)rownumsWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType {
    NSString *sql = @"select count() as rownums from action_lst \
    where \
    member_id = '%@' and action_type = '%@' and record_time = '%@'";
    
    NSString *selSql = [NSString stringWithFormat:sql, memberId, actionType, recordTime];
    
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

- (NSString *)dbStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType {
    NSString *sql = @"select step from action_lst \
    where \
    member_id = '%@' and action_type = '%@' and record_time = '%@' limit 1";
    
    NSString *selSql = [NSString stringWithFormat:sql, memberId, actionType, recordTime];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    FMResultSet *rs = [db executeQuery:selSql];
    
    NSString *step = @"";
    while ([rs next]) {
        step = [rs stringForColumn:@"step"];
    }
    [db close];
    
    return step;
}

- (VHSActionData *)actionWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime actionType:(NSString *)actionType {
    NSArray *actionList = [self selectListWithMemberId:memberId recordTime:recordTime actionType:actionType upload:nil];
    VHSActionData *action = [actionList firstObject];
    return action;
}

- (NSArray *)onedayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime {
    NSArray *onedayActionList = [self selectListWithMemberId:memberId recordTime:recordTime actionType:nil upload:nil];;
    return onedayActionList;
}

- (NSArray *)oneUserActionWithMemberId:(NSString *)memberId actionType:(NSString *)actionType {
    NSArray *actionList = [self selectListWithMemberId:memberId recordTime:nil actionType:actionType upload:nil];
    return actionList;
}

- (NSArray *)oneUserActionListWithMemberId:(NSString *)memberId upload:(NSString *)isUpload {
    NSArray *actionList = [self selectListWithMemberId:memberId recordTime:nil actionType:nil upload:isUpload];
    return actionList;
}

- (NSArray *)selectListWithMemberId:(NSString *)memberId
                         recordTime:(NSString *)recordTime
                         actionType:(NSString *)actionType
                             upload:(NSString *)upload {
    if (!memberId) return @[];
    
    NSString *sql = @"select * from action_lst where ";
    
    if (memberId) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" member_id = '%@' ", memberId]];
    }
    if (recordTime) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and record_time = '%@' ", recordTime]];
    }
    if (actionType) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and action_type = '%@' ", actionType]];
    }
    if (upload) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" and upload = %@ ", upload]];
    }
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next]) {
        NSString *action_id = [rs stringForColumn:@"action_id"];
        NSString *member_id = [rs stringForColumn:@"member_id"];
        NSString *action_type = [rs stringForColumn:@"action_type"];
        NSString *distance = [rs stringForColumn:@"distance"];
        NSString *calorie = [rs stringForColumn:@"calorie"];
        NSString *step = [rs stringForColumn:@"step"];
        NSString *start_time = [rs stringForColumn:@"start_time"];
        NSString *end_time = [rs stringForColumn:@"end_time"];
        NSString *record_time = [rs stringForColumn:@"record_time"];;
        NSString *score = [rs stringForColumn:@"score"];
        NSInteger upload = [rs intForColumn:@"upload"];
        NSString *mac_address = [rs stringForColumn:@"mac_address"];
        
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
        
        [arr addObject:action];
    }
    
    return arr;
}

@end
