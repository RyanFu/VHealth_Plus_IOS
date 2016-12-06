//
//  VHSDataBaseManager.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSDataBaseManager.h"
#import "VHSCommon.h"
#import "VHSDefinition.h"
#import "VHS_Header.h"

/// 手机计步：手机实时数据的回调是在子线程中的，查询数据是在主现场中的，为了避免主线程和子线程同时争抢BD对象，所以每一次数据操作都创建一个新的DB对象

@interface VHSDataBaseManager ()

@end

// action_type 定义当前纪录步数类型
// 4 手环

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
        'action_mode'           INTEGER,\
        'action_type'           VARCHAR(8),\
        'distance'              NUMERIC,\
        'seconds'               INTEGER,\
        'calorie'               INTEGER,\
        'step'                  INTEGER,\
        'start_time'            VARCHAR(36),\
        'end_time'              VARCHAR(36),\
        'record_time'           VARCHAR(36),\
        'score'                 INTEGER,\
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

// 插入一条数据到运动一览表
- (BOOL)insertActionLst:(NSString *)action_id
             member_id:(NSString *)member_id
           action_mode:(NSInteger) action_mode
           action_type:(NSString *)action_type
              distance:(float)distance
               seconds:(NSInteger)seconds
               calorie:(NSInteger)calorie
                  step:(NSInteger)step
            start_time:(NSString *)start_time
              end_time:(NSString *)end_time
           record_time:(NSString *)record_time
                 score:(NSInteger)score
                upload:(NSInteger)upload
           mac_address:(NSString *)mac_address {
    
    if (!action_id.length || !action_id) {
        CLog(@"主键不见");
        return NO;
    }
    if (!member_id.length || !member_id) {
        return NO;
    }
    
    BOOL flag = NO;
    
    // 获取DB对象
    FMDatabase *db = [self getFmdb];
    [db open];
    
    NSString *insertSql = @"INSERT INTO action_lst (action_id, member_id, action_mode, action_type, distance, seconds, calorie, step, start_time, end_time, record_time, score, upload, mac_address) VALUES (? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    flag = [db executeUpdate:insertSql, action_id, member_id, @(action_mode), action_type, @(distance), @(seconds), @(calorie), @(step), start_time, end_time, record_time, @(score), @(upload), mac_address];
    
    if (flag) {
        CLog(@"插入一条数据成功");
    } else {
        CLog(@"插入一条数据失败");
    }
    
    [db close];
    
    return flag;
}

- (void)insertOrUpdateM7ActionLst:(NSString *)action_id
                        member_id:(NSString *)member_id
                      action_mode:(NSInteger) action_mode
                      action_type:(NSString *)action_type
                         distance:(float)distance
                          seconds:(NSInteger)seconds
                          calorie:(NSInteger)calorie
                             step:(NSInteger)step
                       start_time:(NSString *)start_time
                         end_time:(NSString *)end_time
                      record_time:(NSString *)record_time
                            score:(NSInteger)score
                           upload:(NSInteger)upload
                      mac_address:(NSString *)mac_address {
 
    FMDatabase *db = [self getFmdb];
    [db open];
        
    if ([VHSCommon isNullString:member_id] || [VHSCommon isNullString:record_time]) {
        [db close];
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select action_id, step from action_lst where record_time = '%@' and action_type = '%@' and member_id = %@", record_time, action_type, member_id];
    FMResultSet *rs = [db executeQuery:sql];
    BOOL flag = NO;
    NSString *actionId = nil;
    NSInteger steps = 0;
    while ([rs next]) {
        actionId = [rs stringForColumn:@"action_id"];
        steps = [rs intForColumn:@"step"];
        if (actionId) {
            flag = YES;
        }
    }
    
    // 加一个判断，如果结果rs结果集nil，直接返回
    if (!rs) return;
    
    if (flag) {
        // 增量大于0才进行更新
        if (step > 0) {
            // 存在该数据 －－ 更新
            NSString *destSteps = [@(steps + step) stringValue];
            NSString *updateSql = [NSString stringWithFormat:@"update action_lst set step = %@, upload = 0, end_time = '%@' where record_time = '%@' and action_type = %@  and member_id = %@", destSteps, end_time, record_time, action_type, member_id];
            BOOL res = [db executeUpdate:updateSql];
            if (res) {
                CLog(@"更新一条数据成功－－－－－success");
            }
        }
    }
    else {
        // 不存在该数据 －－ 插入
        BOOL res = [self insertActionLst:action_id
                               member_id:member_id
                             action_mode:action_mode
                             action_type:action_type
                                distance:action_mode
                                 seconds:seconds
                                 calorie:calorie
                                    step:step
                              start_time:[VHSCommon getDate:[NSDate date]]
                                end_time:[VHSCommon getDate:[NSDate date]]
                             record_time:record_time
                                   score:score
                                  upload:upload
                             mac_address:mac_address];
        if (res) {
            CLog(@"插入一条数据成功－－－－－success");
        }
    }
    
    [db close];
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
    NSMutableArray *unUploadList = [NSMutableArray new];
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM action_lst WHERE member_id = %@ AND upload = 0 ORDER BY action_id desc", memberId];
    
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        NSString *action_id = [rs stringForColumn:@"action_id"];
        NSString *action_type = [rs stringForColumn:@"action_type"];
        double distance = [rs doubleForColumn:@"distance"];
        NSInteger calorie = [rs intForColumn:@"calorie"];
        NSInteger step = [rs intForColumn:@"step"];
        NSString *start_time = [rs stringForColumn:@"start_time"];
        NSString *end_time = [rs stringForColumn:@"end_time"];
        NSString *record_time = [rs stringForColumn:@"record_time"];
        NSInteger score = [rs intForColumn:@"score"];
        NSInteger upload = [rs intForColumn:@"upload"];
        NSString *mac_address = [rs stringForColumn:@"mac_address"];
        
        VHSActionData *action = [[VHSActionData alloc] init];
        action.actionId = action_id;
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
        
        [unUploadList addObject:action];
    }
        
    [db close];
    
    return unUploadList;
}

- (NSInteger)selectSumDayStepsFromActionLst:(NSString *)memberId ymd:(NSString *)ymd {
    NSInteger sum = 0;
    
    FMDatabase *db = [self getFmdb];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT SUM(step) as steps FROM action_lst WHERE member_id = %@ AND record_time = '%@'", memberId, ymd];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        sum = [rs intForColumn:@"steps"];
    }
    
    [db close];

    return sum;
}

- (void)insertOrUpdateBleActionLst:(NSString *)action_id
                         member_id:(NSString *)member_id
                       action_mode:(NSInteger) action_mode
                       action_type:(NSString *)action_type
                          distance:(float)distance
                           seconds:(NSInteger)seconds
                           calorie:(NSInteger)calorie
                              step:(NSInteger)steps
                        start_time:(NSString *)start_time
                          end_time:(NSString *)end_time
                       record_time:(NSString *)record_time
                             score:(NSInteger)score
                            upload:(NSInteger)upload
                       mac_address:(NSString *)mac_address {
    
    FMDatabase *db = [self getFmdb];
    [db open];
        
    NSString *sql = [NSString stringWithFormat:@"select action_id, step from action_lst where record_time = '%@' and action_type = '%@' and member_id = '%@'", record_time, action_type, member_id];
    FMResultSet *rs = [db executeQuery:sql];
    BOOL flag = NO;
    NSString *actionId = nil;
    NSInteger step = 0;
    while ([rs next]) {
        actionId = [rs stringForColumn:@"action_id"];
        step = [rs intForColumn:@"step"];
        if (actionId) {
            flag = YES;
        }
    }
    
    if (flag) {
        if (steps > 0) {
            // 存在该数据 －－ 更新
            NSString *destSteps = [@(steps + step) stringValue];
            NSString *updateSql = [NSString stringWithFormat:@"update action_lst set step = %@, upload = 0, end_time = '%@' where record_time = '%@' and action_type = %@ and member_id = '%@'", destSteps, [VHSCommon getDate:[NSDate date]], record_time, action_type, member_id];
            BOOL res = [db executeUpdate:updateSql];
            if (res) {
                CLog(@"更新一条数据成功－－－－－success");
            }
        }
    }
    else {
        // 不存在该数据 －－ 插入
        BOOL res = [self insertActionLst:action_id
                               member_id:[[VHSCommon userDetailInfo].memberId stringValue]
                             action_mode:0
                             action_type:action_type
                                distance:0.0
                                 seconds:0
                                 calorie:0
                                    step:steps
                              start_time:[VHSCommon getDate:[NSDate date]]
                                end_time:[VHSCommon getDate:[NSDate date]]
                             record_time:record_time
                                   score:0
                                  upload:0
                             mac_address:[k_UserDefaults objectForKey:k_SHOUHUAN_MAC_ADDRESS]];
        if (res) {
            CLog(@"插入一条数据成功－－－－－success");
        }
    }
    
    [db close];
}

/// 更新数据库中的数据
- (void)updateSportStepWithActionData:(VHSActionData *)action {
    
    FMDatabase *db = [self getFmdb];
    [db open];
        
    NSString *sql = [NSString stringWithFormat:@"select action_id, step from action_lst where record_time = '%@' and action_type = '%@' and member_id = '%@'", action.recordTime, action.actionType, action.memberId];
    FMResultSet *rs = [db executeQuery:sql];
    BOOL exsit = NO;
    NSString *actionId = nil;
    NSInteger step = 0;
    while ([rs next]) {
        actionId = [rs stringForColumn:@"action_id"];
        step = [rs intForColumn:@"step"];
        if (actionId) {
            exsit = YES;
        }
    }
    
    // 更新
    if (exsit) {
        // 只有当云端数据大于本地数据是更新
        if (action.step > step) {
            NSString *sql = [NSString stringWithFormat:@"update action_lst set step = '%@', distance = %@ where mac_address = '%@' and member_id = '%@' and record_time = '%@'", @(action.step), @(action.distance), action.macAddress, action.memberId, action.recordTime];
            [db executeUpdate:sql];
        }
    } else {
        [self insertActionLst:[VHSCommon getTimeStamp]
                    member_id:action.memberId
                  action_mode:0
                  action_type:action.actionType
                     distance:action.distance
                      seconds:0
                      calorie:0
                         step:action.step
                   start_time:[VHSCommon getDate:[NSDate date]]
                     end_time:[VHSCommon getDate:[NSDate date]]
                  record_time:action.recordTime
                        score:0
                       upload:action.upload
                  mac_address:action.macAddress];
    }
    
    [db close];
}

@end
