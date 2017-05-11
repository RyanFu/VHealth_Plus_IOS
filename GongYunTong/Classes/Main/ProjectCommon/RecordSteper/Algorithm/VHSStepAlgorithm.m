//
//  VHSStepAlgorithm.m
//  GongYunTong
//
//  Created by ios-bert on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSStepAlgorithm.h"
#import "VHSDataBaseManager.h"
#import "VHSFitBraceletStateManager.h"
#import "NSArray+VHSExtension.h"
#import "NSDate+VHSExtension.h"
#import "VHSSecurityUtil.h"

@interface VHSStepAlgorithm ()

@property (nonatomic, strong) NSTimer *bleTimer;

@end

@implementation VHSStepAlgorithm

#pragma mark - 初始化

+ (VHSStepAlgorithm *)shareAlgorithm {
    static VHSStepAlgorithm *algorithm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        algorithm = [[VHSStepAlgorithm alloc] init];
    });
    return algorithm;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _stepsData = [[VHSActionData alloc] init];
        _pedometer = [[CMPedometer alloc] init];
        
        VHSDataBaseManager *dm = [[VHSDataBaseManager alloc] init];
        [dm createDB];
    }
    return self;
}

- (void)startBleStepRecord {
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
        [self.pedometer stopPedometerUpdates];
        // 连接了手环，初始化手环设备
        [VHSBraceletCoodinator sharePeripheral];
    }
}

- (void)startMobileStepRecord {
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        if ([CMPedometer isStepCountingAvailable]) {
            [self.pedometer stopPedometerUpdates];
            [self getHistoryHealthSportData];
        }
    }
}

- (void)stopPedometerCount {
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        if ([CMPedometer isStepCountingAvailable]) {
            [self.pedometer stopPedometerUpdates];
        }
    }
}

- (void)getHistoryHealthSportData {
    
    __block NSString *lastSyncM7DateStr = [VHSCommon getUserDefautForKey:k_M7_MOBILE_SYNC_TIME];
    
//    lastSyncM7DateStr = @"2017-05-09 20:26:05";
    
    if ([VHSCommon isNullString:lastSyncM7DateStr]) {
        lastSyncM7DateStr = [VHSCommon getDate:[NSDate date]];
    }
    // 跨了几天
    NSInteger pastdays = [NSDate pastOfNowWithPastDateStr:lastSyncM7DateStr];
    for (NSInteger i = pastdays; i >= 0; i--) {
        NSString *endTime = [NSDate yyyymmddhhmmssEndByPastDays:i];
        if (i == 0) {
            endTime = [VHSCommon getDate:[NSDate date]];
        }
        NSDate *startDate = [VHSCommon dateWithDateStr:lastSyncM7DateStr];
        NSDate *endDate = [VHSCommon dateWithDateStr:endTime];
        [self.pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            CLog(@"--->>>历史数据:%@时到%@时产生了%@步数", [VHSCommon getDate:startDate], [VHSCommon getDate:endDate], pedometerData.numberOfSteps);
            
            // 历史数据存在插入
            if (pedometerData.numberOfSteps.integerValue > 0) {
                VHSActionData *action = [[VHSActionData alloc] init];
                action.actionId = [VHSCommon getTimeStamp];
                action.memberId = [[VHSCommon userInfo].memberId stringValue];
                action.actionMode = 0;
                action.actionType = @"2";
                action.upload = 0;
                action.macAddress = @"0";
                action.step = [pedometerData.numberOfSteps stringValue];
                action.initialStep = @"0";
                action.startTime = [VHSCommon getDate:startDate];
                action.endTime = [VHSCommon getDate:endDate];
                action.recordTime = [NSDate ymdByPastDay:i];
                action.currentDeviceStep = [pedometerData.numberOfSteps stringValue];
                [self insertAction:action];
            }

            // 开启手机计步
            if (i == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]] forKey:k_M7_MOBILE_SYNC_TIME];
                });
                // 开启实时计步策略
                [self beginM7RealtimeStepLive];
            }
        }];
        // 跨天
        lastSyncM7DateStr = [[NSDate yyyymmddhhmmssStartByPastDays:i - 1] copy];
    }
}

// 获取实时手机产生的运动数据
- (void)beginM7RealtimeStepLive {
    // 不能进行计步操作
    if (![CMPedometer isStepCountingAvailable]) return;
    
    __block NSString *realtimeStepDate = [VHSCommon getDate:[NSDate date]];
    __block BOOL isFirstRun = YES;
    
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        CLog(@"---->>>>start:%@--->>> shouji-steps:%@", [VHSCommon getDate:[NSDate date]], pedometerData.numberOfSteps);
        
        @synchronized (self) {
            if (isFirstRun) {
                // 实时数据开始更新前准备数据
                VHSActionData *action = [[VHSActionData alloc] init];
                action.actionId = [VHSCommon getTimeStamp];
                action.memberId = [[VHSCommon userInfo].memberId stringValue];
                action.actionMode = @"0";
                action.actionType = @"2";
                action.upload = 0;
                action.distance = @"0";
                action.calorie = @"0";
                action.macAddress = @"0";
                action.step = @"0";
                action.startTime = [VHSCommon getDate:[NSDate date]];
                action.endTime = [VHSCommon getDate:[NSDate date]];
                action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
                action.currentDeviceStep = @"0";
                action.initialStep = @"0";
                [self insertAction:action];
                
                isFirstRun = NO;
            }
            
            NSString *memberId = [VHSCommon userInfo].memberId.stringValue;
            if ([VHSCommon isNullString:memberId]) {
                return;
            }
            
            // 通过数据库判断是否有数据来进行判断是否跨天
            NSString *recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
            VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
            VHSActionData *oldActionData = [manager queryLatestActionWithMemberId:memberId mac:@"0" recordTime:recordTime];
            if (!oldActionData) {
                [self.pedometer stopPedometerUpdates];
                // 跨天，从新开始计步处理
                [self beginM7RealtimeStepLive];
                return;
            }
        
            VHSActionData *action = [[VHSActionData alloc] init];
            action.actionId = [VHSCommon getTimeStamp];
            action.memberId = [[VHSCommon userInfo].memberId stringValue];
            action.actionMode = @"0";
            action.actionType = @"2";
            action.upload = 0;
            action.distance = @"0";
            action.calorie = @"0";
            action.macAddress = @"0";
            action.step = pedometerData.numberOfSteps.stringValue;
            action.startTime = realtimeStepDate;
            action.endTime = [VHSCommon getDate:[NSDate date]];
            action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
            action.currentDeviceStep = pedometerData.numberOfSteps.stringValue;
            [self updateAction:action];
            
            // 更新手机同步时间
            dispatch_async(dispatch_get_main_queue(), ^{
                [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]] forKey:k_M7_MOBILE_SYNC_TIME];
            });
        };
    }];
}

#pragma mark - 同步手环数据到手机

- (void)asynDataFromBraceletToMobileDB:(void (^)())syncSuccess {
    
    if ([VHSCommon isBetweenZeroMomentFiveMinute]) {
        return;
    }
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStatebindConnected) {
        return;
    }
    // 当天，不走历史数据
    NSString *bindTime = [VHSCommon getShouHuanBoundTime];
    NSInteger pastday = [NSDate pastOfNowWithPastDateStr:bindTime];
    if (pastday == 0) {
        if (syncSuccess) {
            syncSuccess();
        }
        return;
    }
    
    @synchronized (self) {
        // 厂商手环数据同步到手环厂商的数据库
        [[VHSBraceletCoodinator sharePeripheral] getBraceletorSendSportDataForThedayWithCallBack:^(id object, int errorCode) {
            // 获取历史数据
            [[VHSBraceletCoodinator sharePeripheral] getBraceletorGetAllHealthDataWithCallBack:^(id object, int errorCode) {
                NSArray *allDataArray = (NSArray *)object;
                
                NSArray *allSportList = [allDataArray firstObject];
                if ([allSportList count]) {
                    for (ProtocolSportDataModel *sport in allSportList) {
                        // 历史数据是当天不保存到数据库
                        NSString *nowDate = [VHSCommon getYYYYmmddDate:[NSDate date]];
                        if ([nowDate isEqualToString:sport.date]) {
                            continue;
                        }
                        
                        NSString *mac = sport.smart_device_id;
                        if ([VHSCommon isNullString:mac]) {
                            continue;
                        }
                        
                        // yyyyMMdd转出格式为yyyy-MM-dd
                        NSString *sportDate = [VHSCommon dateStrFromYYYYMMDD:sport.date];
                        
                        VHSActionData *action = [[VHSActionData alloc] init];
                        action.actionId = [VHSCommon getTimeStamp];
                        action.memberId = [[VHSCommon userInfo].memberId stringValue];
                        action.startTime = [VHSCommon dateStrFromYYYYMMDDToDate:sport.date]; // 历史数据更新时间为历史时间的59分59秒
                        action.recordTime = sportDate;
                        action.step = [@(sport.total_step) stringValue];
                        action.actionType = @"1";
                        action.upload = 0;
                        action.initialStep = @(0).stringValue;
                        action.currentDeviceStep = @(0).stringValue;
                        action.macAddress = mac;
                        action.actionMode = @"0";
                        action.distance = @"0";
                        action.seconds = @"0";
                        action.calorie = @"0";
                        action.score = @"0";
                        action.endTime = [VHSCommon dateStrFromYYYYMMDDToDate:sport.date];
                        
                        [self updateAction:action];
                    }
                }
                
                // 更新手环绑定时间
                // [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]] forKey:k_SHOUHUAN_BOUND_TIME];
                
                // 同步到自己表中成功后的回调
                if (syncSuccess) {
                    syncSuccess();
                }
            }];
        }];
    };
}

#pragma mark - 手环相关

-(NSTimer *)bleTimer {
    _bleTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(realtimeBLEData) userInfo:nil repeats:YES];
    
    return _bleTimer;
}

- (void)fireTimer {
    [self.bleTimer fire];//开启定时器
}

- (void)invalidateTimer {
    if ([_bleTimer isValid]) {
        [_bleTimer invalidate];
    }
}

- (void)realtimeBLEData {
    if ([VHSCommon isBetweenZeroMomentFiveMinute]) {
        return;
    }
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind || [VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindDisConnected) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[VHSBraceletCoodinator sharePeripheral] getBraceletorRealtimeDataWithCallBack:^(ProtocolLiveDataModel *liveData, int errorCode) {
        
        NSString *mac = liveData.smart_device_id;
        if ([VHSCommon isNullString:mac]) {
            return;
        }
        
        // 时刻更新手环数据到数据库表
        VHSActionData *action = [[VHSActionData alloc] init];
        action.actionId = [VHSCommon getTimeStamp];
        action.startTime = [VHSCommon getDate:[NSDate date]];
        action.initialStep = @"0";
        action.currentDeviceStep = @(liveData.step).stringValue;
        action.step = @(liveData.step).stringValue;
        action.memberId = [VHSCommon userInfo].memberId.stringValue;
        action.actionType = @"1";
        action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
        action.upload = 0;
        action.macAddress = mac;
        action.actionMode = @"0";
        action.distance = @"0";
        action.seconds = @"0";
        action.calorie = @"0";
        action.endTime = [VHSCommon getDate:[NSDate date]];
        action.score = @"0";
        [self updateAction:action];
        
        weakSelf.stepsData.step = [NSString stringWithFormat:@"%@", @(liveData.step)];
        weakSelf.stepsData.calorie = [NSString stringWithFormat:@"%@", @(liveData.calories)];
        weakSelf.stepsData.distance = [NSString stringWithFormat:@"%@", @(liveData.distances)];
        weakSelf.stepsData.macAddress = liveData.smart_device_id;
    }];
}

#pragma mark - 数据库逻辑操作部分

- (void)insertOrUpdateActionToMobileFromM7:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    
    VHSActionData *mobileAction = [manager queryLatestActionWithMemberId:action.memberId mac:@"0" recordTime:action.recordTime];
    
    if (mobileAction) {
        // 更新数据
        [manager updateNewAction:action];
    } else {
        // 新增数据
        [manager insertNewAction:action];
    }
}

- (NSInteger)getsDayStepWithMemberId:(NSString *)memberId recordTime:(NSString *)recordTime {
    
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    NSArray *actionList = [manager queryOnedayStepWithMemberId:memberId recordTime:recordTime];
    
    NSInteger sum = 0;
    for (VHSActionData *action in actionList) {
        sum += [action.step integerValue];
    }
    return sum;
}

- (void)uploadAllUnuploadActionData:(void (^)(NSDictionary *))syncBlock {
    
    if (![VHSCommon isNetworkAvailable]) return;
    
    if ([VHSCommon isBetweenZeroMomentFiveMinute]) {
        return;
    }
    
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    
    NSString *memberId = [[VHSCommon userInfo].memberId stringValue];
    if ([VHSCommon isNullString:memberId]) {
        if (syncBlock) syncBlock(nil);
        return;
    }
    
    // 获取所有该用户未上传的数据
    NSArray *upUploadList = [manager queryUnUploadActionListWithMemberId:memberId];
    if (![upUploadList count]) {
        [VHSCommon setUploadServerTime:[VHSCommon getDate:[NSDate date]]];
        if (syncBlock) syncBlock(@{@"result" : @200});
        return;
    }
    
    // 获取当天所有mac地址的步数
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    for (VHSActionData *action in upUploadList) {
        NSString *key = [NSString stringWithFormat:@"%@:%@", action.recordTime, action.macAddress];
        
        if ([action.macAddress isEqualToString:@"0"]) {
            if (![map.allKeys containsObject:key]) {
                [map setObject:action.step forKey:key];
            } else {
                NSInteger step = [map[key] integerValue] + action.step.integerValue;
                [map setObject:@(step).stringValue forKey:key];
            }
        } else {
            if (![map.allKeys containsObject:key]) {
                [map setObject:action.step forKey:key];
            } else {
                NSInteger step = [map[key] integerValue] + action.step.integerValue;
                [map setObject:@(step).stringValue forKey:key];
            }
        }
    }
    
    // 拼接数据用于上传数据
    NSMutableArray *jsonStepsList = [NSMutableArray new];
    for (NSString *key in map) {
        NSArray *keys = [key componentsSeparatedByString:@":"];
        NSString *recordTime = keys.firstObject;
        NSString *mac = keys.lastObject;
        
        NSString *step = [map objectForKey:key];
        
        if (step.integerValue <= 0 || step.integerValue >= 50000 || [VHSCommon isNullString:mac] || [mac containsString:@"null"]) {
            continue;
        }
        
        NSDictionary *actionDict = @{@"sportDate" : recordTime , @"step" : step, @"handMac" : mac};
        [jsonStepsList addObject:actionDict];
    }
    
    // 没有可以上传的数据
    if (![jsonStepsList count]) return;
    
    // NSArray convert to Json
    NSString *jsonSteps = [jsonStepsList convertJson];
    
    // 本地数据上传
    NSString *signTimeStamp = [VHSCommon getTimeStamp];
    NSString *signStr = [NSString stringWithFormat:@"%@%@", [VHSCommon vhstoken], signTimeStamp];
    NSString *sign = [VHSUtils md5_base64:signStr];
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_ADD_STEP;
    message.httpMethod = VHSNetworkPOST;
    message.sign = sign;
    message.params = @{@"steps" : jsonSteps, @"timestamp" : signTimeStamp};
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSArray *kmList = result[@"kmList"];
            // 更新本地数据库中的上传状态
            for (NSDictionary *kmDict in kmList) {
                NSString *sportDate = kmDict[@"sportDate"];
                NSString *mac = [kmDict[@"handMac"] lowercaseString];
                NSString *km = kmDict[@"km"];
                [manager updateActionStatus:sportDate mac:mac distance:km];
            }
            [VHSCommon setUploadServerTime:[VHSCommon getDate:[NSDate date]]];
        }
        if (syncBlock) {
            syncBlock(result);
        }
    } fail:^(NSError *error) {
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

/// 更新运动步数
- (void)updateSportStep:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    
    NSInteger rownum = [manager rownumsWithAction:action];
    if (rownum > 0) {
        [manager updateNewAction:action];
    } else {
        [manager insertNewAction:action];
    }
}

- (BOOL)insertAction:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    BOOL flag = [manager insertNewAction:action];
    return flag;
}

- (void)updateAction:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    [manager updateNewAction:action];
}

- (void)deleteAllAction {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    [manager deleteAllAction];
}

@end
