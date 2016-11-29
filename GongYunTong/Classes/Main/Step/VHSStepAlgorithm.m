//
//  VHSStepAlgorithm.m
//  GongYunTong
//
//  Created by ios-bert on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSStepAlgorithm.h"
#import "VHSDataBaseManager.h"
#import "VHSFitBraceletStateManager.h"
#import "NSArray+VHSExtension.h"
#import "NSDate+VHSExtension.h"

@interface VHSStepAlgorithm ()

@property (nonatomic, strong) NSTimer *bleTimer;
@property (nonatomic, strong) ASDKGetHandringData *ASDKHandler;

@property (nonatomic, assign) NSInteger lastSynaM7Steps;

@end

@implementation VHSStepAlgorithm

#pragma mark - override getter method 

-(ASDKGetHandringData *)ASDKHandler {
    if (!_ASDKHandler) {
        _ASDKHandler = [[ASDKGetHandringData alloc] init];
    }
    return _ASDKHandler;
}

#pragma mark - 初始化

+ (VHSStepAlgorithm *)shareAlgorithm {
    static VHSStepAlgorithm *algorithm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        algorithm = [[VHSStepAlgorithm alloc] init];
    });
    return algorithm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stepsData = [[VHSActionData alloc]init];
        
        VHSDataBaseManager *dm = [[VHSDataBaseManager alloc] init];
        [dm createDB];
        [dm createTable];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:nowDate];
        
        _stepsData.date = dateStr;
    }
    return self;
}

- (void)shareBLE {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 手环初始化
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        ASDKShareFunction *asdk = [[ASDKShareFunction alloc] init];
#pragma clang diagnostic pop
        [SharePeripheral sharePeripheral].bleMolue = [[ASDKBleModule alloc] init];
    });
}

#pragma mark - 尝试重新绑定手环

- (void)tryReconnectedBracelet {
    AppDelegate *delegate = APP_DELEGATE;
    [delegate initConnectPeripheralSuccess:nil];
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindDisConnected) {
        NSString *uuid = [k_UserDefaults objectForKey:k_SHOUHUAN_UUID];
        if (!uuid) return;
        [[SharePeripheral sharePeripheral].bleMolue ASDKSendConnectDevice:uuid];
    }
}

- (void)start {
    [self acce];
}

// 手机计步
- (void)acce {
    
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
        return;
    }
    
    __block NSString *lastSyncM7DateStr = [VHSCommon getUserDefautForKey:k_M7_MOBILE_SYNC_TIME];
    if ([VHSCommon isNullString:lastSyncM7DateStr]) {
        lastSyncM7DateStr = [VHSCommon getDate:[NSDate date]];
    }
    NSInteger lastDays = [NSDate pastOfNowWithPastDateStr:lastSyncM7DateStr];
    
    // 应用启动(没有驻后台)
    if (lastDays > 0) {
        for (NSInteger i = lastDays; i >= 0; i--) {
            NSString *endTime = [NSDate yyyymmddhhmmssEndByPastDays:i];
            if (i == 0) {
                endTime = [VHSCommon getDate:[NSDate date]];
            }
            if ([CMPedometer isStepCountingAvailable]) {
                [self.pedometer queryPedometerDataFromDate:[VHSCommon dateWithDateStr:lastSyncM7DateStr]
                                                    toDate:[VHSCommon dateWithDateStr:endTime]
                                               withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       VHSActionData *action = [[VHSActionData alloc] init];
                                                       action.actionId = [VHSCommon getTimeStamp];
                                                       action.memberId = [[VHSCommon userInfo].memberId stringValue];
                                                       action.actionMode = 0;
                                                       action.actionType = @"2";
                                                       action.upload = 0;
                                                       action.macAddress = @"0";
                                                       action.step = [pedometerData.numberOfSteps integerValue];
                                                       action.startTime = [NSDate ymdByPastDay:i];
                                                       action.endTime = endTime;
                                                       action.recordTime = [NSDate ymdByPastDay:i];
                                                       
                                                       [self insertOrUpdateActionToMobileFromM7:action];
                                                   });
                                               }];
                if (i != 0) {
                    lastSyncM7DateStr = [[NSDate yyyymmddhhmmssStartByPastDays:i - 1] copy];
                } else {
                    [k_UserDefaults setObject:[VHSCommon getDate:[NSDate date]] forKey:k_M7_MOBILE_SYNC_TIME];
                    [k_UserDefaults synchronize];
                    
                    // 开启手机步数实时更新
                    [self beginM7RealtimeStepLive];
                }
            }
        }
    } else {
        if ([CMPedometer isStepCountingAvailable]) {
            [self.pedometer queryPedometerDataFromDate:[VHSCommon dateWithDateStr:lastSyncM7DateStr]
                                                toDate:[NSDate date]
                                           withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   VHSActionData *action = [[VHSActionData alloc] init];
                                                   action.actionId = [VHSCommon getTimeStamp];
                                                   action.memberId = [[VHSCommon userInfo].memberId stringValue];
                                                   action.actionMode = 0;
                                                   action.actionType = @"2";
                                                   action.upload = 0;
                                                   action.macAddress = @"0";
                                                   action.step = [pedometerData.numberOfSteps integerValue];
                                                   action.startTime = [VHSCommon getDate:[NSDate date]];
                                                   action.endTime = [VHSCommon getDate:[NSDate date]];
                                                   action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
                                                   
                                                   [self insertOrUpdateActionToMobileFromM7:action];
                                                   
                                                   // 更新手机同步时间
                                                   [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]]
                                                                       forKey:k_M7_MOBILE_SYNC_TIME];
                                                   // 开启实时步数实时更新
                                                   [self beginM7RealtimeStepLive];
                                               });
                                           }];
        }
    }
}

// 获取实时手机产生的运动数据
- (void)beginM7RealtimeStepLive {
    CLog(@"-------beginM7RealtimeStepLive");
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date]
                                      withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                                              
                                              CLog(@"shouji-steps:%@", pedometerData.numberOfSteps);
                                              if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
                                                  [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]]
                                                                      forKey:k_M7_MOBILE_SYNC_TIME];
                                                  self.lastSynaM7Steps = pedometerData.numberOfSteps.integerValue;
                                                  return;
                                              }
                                              
                                              __block NSString *lastSyncTime = [k_UserDefaults objectForKey:k_M7_MOBILE_SYNC_TIME];
                                              if ([VHSCommon isNullString:lastSyncTime]) {
                                                  lastSyncTime = [VHSCommon getDate:[NSDate date]];
                                              }
                                              
                                              NSInteger lastDays = [NSDate pastOfNowWithPastDateStr:lastSyncTime];
                                              
                                              if (lastDays > 0) {
                                                  for (NSInteger i = lastDays; i >= 0; i--) {
                                                      NSString *endTime = [NSDate yyyymmddhhmmssEndByPastDays:i];
                                                      [self.pedometer queryPedometerDataFromDate:[VHSCommon dateWithDateStr:lastSyncTime]
                                                                                          toDate:[VHSCommon dateWithDateStr:endTime]
                                                                                     withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                                                                                         VHSActionData *action = [[VHSActionData alloc] init];
                                                                                         action.actionId = [VHSCommon getTimeStamp];
                                                                                         action.memberId = [[VHSCommon userInfo].memberId stringValue];
                                                                                         action.actionMode = 0;
                                                                                         action.actionType = @"2";
                                                                                         action.upload = 0;
                                                                                         action.macAddress = @"0";
                                                                                         action.step = pedometerData.numberOfSteps.integerValue;
                                                                                         action.startTime = [NSDate ymdByPastDay:i];
                                                                                         action.endTime = endTime;
                                                                                         action.recordTime = [NSDate ymdByPastDay:i];
                                                                                         
                                                                                         // 主线程更新数据
                                                                                         [self insertOrUpdateActionToMobileFromM7:action];
                                                                                     }];
                                                      if (i != 0) {
                                                          lastSyncTime = [NSDate yyyymmddhhmmssStartByPastDays:i - 1];
                                                      } else {
                                                          [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]]
                                                                              forKey:k_M7_MOBILE_SYNC_TIME];
                                                      }
                                                  }
                                              } else {
                                                  VHSActionData *action = [[VHSActionData alloc] init];
                                                  action.actionId = [VHSCommon getTimeStamp];
                                                  action.memberId = [[VHSCommon userInfo].memberId stringValue];
                                                  action.actionMode = 0;
                                                  action.actionType = @"2";
                                                  action.upload = 0;
                                                  action.macAddress = @"0";
                                                  action.step = pedometerData.numberOfSteps.integerValue - self.lastSynaM7Steps;
                                                  action.startTime = [VHSCommon getDate:[NSDate date]];
                                                  action.endTime = [VHSCommon getDate:[NSDate date]];
                                                  action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
                                                  
                                                  [self insertOrUpdateActionToMobileFromM7:action];
                                                  // 更新手机同步时间
                                                  [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]]
                                                                      forKey:k_M7_MOBILE_SYNC_TIME];
                                              }
                                              self.lastSynaM7Steps = pedometerData.numberOfSteps.integerValue;
                                      }];
    
}

- (CMPedometer *)pedometer {
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return _pedometer;
}

#pragma mark - 同步手环数据到手机

- (void)asynDataFromBraceletToMobileDB:(void (^)())syncSuccess {
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {

        [self asynDataMySelfTable:^(int errorCode) {
            
            NSString *bindTime = [VHSCommon getShouHuanBoundTime];
            NSInteger pastday = [NSDate pastOfNowWithPastDateStr:bindTime];
            
            for (NSInteger i = pastday; i >= 0; i--) {
                NSString *pastTime = [NSDate yyyymmddByPastDays:i];
                NSString *pastYMD = [NSDate ymdByPastDay:i];
                [self sportDayWithDate:pastTime sportBlock:^(ProtocolSportDataModel *sportData) {
                    CLog(@"时间：%@ 一天的总步数--------> %ld", pastTime, (long)sportData.total_step);
                    NSInteger syncSteps = [VHSCommon getShouHuanLastStepsSync];
                    
                    VHSActionData *action = [[VHSActionData alloc] init];
                    action.memberId = [[VHSCommon userInfo].memberId stringValue];
                    action.actionId = [VHSCommon getTimeStamp];
                    action.step = sportData.total_step - syncSteps;
                    action.actionType = @"1";
                    action.recordTime = pastYMD;
                    [self insertOrUpdateBleAction:action];
                    
                    [VHSCommon setShouHuanLastStepsSync:sportData.total_step];
                    [VHSCommon setShouHuanLastTimeSync:[VHSCommon getDate:[NSDate date]]];
                    if (pastday > 0 && i > 0) {
                        [VHSCommon setShouHuanLastStepsSync:0];
                    }
                    
                    // 同步到自己表中成功后的回调
                    if (syncSuccess) {
                        syncSuccess();
                    }
                }];
            }
            // 隔天数据
            if (pastday > 0) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
                cmps.hour = 0;
                cmps.minute = 0;
                cmps.second = 1;
                NSDate *currentStart = [calendar dateFromComponents:cmps];
                
                [k_UserDefaults setObject:[VHSCommon getDate:currentStart] forKey:k_SHOUHUAN_BOUND_TIME];
                [k_UserDefaults synchronize];
            }
        }];
    }
}

- (void)asynDataMySelfTable:(void (^)(int errorCode))syncBlock {
    [self.ASDKHandler ASDKSendRequestSportDataForTodayWithUpdateBlock:^(id object, int errorCode) {
        if (syncBlock) {
            syncBlock(errorCode);
        }
    }];
}

/// 获取手环中指定一天的数据
- (void)sportDayWithDate:(NSString *)date sportBlock:(void (^)(ProtocolSportDataModel *sportData))sportDataBlock {
    ASDKGetHandringData *handler = [[ASDKGetHandringData alloc] init];
    ProtocolSportDataModel *daySport = [handler ASDKSendGetSportData:date
                                                       AndDevicePkId:[k_UserDefaults objectForKey:k_SHOUHUAN_MAC_ADDRESS]];
    if (sportDataBlock) {
        sportDataBlock(daySport);
    }
}
/// 获取手环实时的信息
- (void)realtimeBraceletDataBlock:(void (^)(ProtocolLiveDataModel *liveData))realtimeBlock {
    [self.ASDKHandler ASDKSendDataToAcceptRealTimeDataWithUpdateBlock:^(ProtocolLiveDataModel *object, int errorCode) {
        if (realtimeBlock) {
            realtimeBlock(object);
        }
    }];
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
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    // 实时获取设备信息
    [self realtimeBraceletDataBlock:^(ProtocolLiveDataModel *liveData) {
        weakSelf.stepsData.step = liveData.step;
        weakSelf.stepsData.calorie = liveData.calories;
        weakSelf.stepsData.distance = liveData.distances;
        weakSelf.stepsData.macAddress = liveData.smart_device_id;
    }];
}

- (void)insertOrUpdateActionToMobileFromM7:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    
    [manager insertOrUpdateM7ActionLst:action.actionId
                             member_id:action.memberId
                           action_mode:action.actionMode
                           action_type:action.actionType
                              distance:action.distance
                               seconds:action.seconds
                               calorie:action.calorie
                                  step:action.step
                            start_time:action.startTime
                              end_time:action.endTime
                           record_time:action.recordTime
                                 score:action.score
                                upload:action.upload
                           mac_address:action.macAddress];
}

- (NSInteger)selecteSumStepsWithMemberId:(NSString *)memberId date:(NSString *)date {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    
    NSInteger sumSteps = 0;
    sumSteps = [manager selectSumDayStepsFromActionLst:memberId
                                                   ymd:date];
    return sumSteps;
}

- (void)uploadAllUnuploadActionData:(void (^)(NSDictionary *))syncBlock {
    
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    
    NSString *memberId = [[VHSCommon userInfo].memberId stringValue];
    if ([VHSCommon isNullString:memberId]) {
        if (syncBlock) syncBlock(nil);
        return;
    }
    // 获取所有该用户未上传的数据
    NSArray *unuploadList = [manager selectUnuploadFromActionLst:memberId];
    if (![unuploadList count]) {
        [VHSCommon setUploadServerTime:[VHSCommon getDate:[NSDate date]]];
        if (syncBlock) syncBlock(@{@"result" : @200});
        return;
    }
    
    // 拼接数据用于上传数据
    NSMutableArray *jsonStepsList = [NSMutableArray new];
    for (VHSActionData *action in unuploadList) {
        NSDictionary *actionDict = @{@"sportDate" : action.recordTime , @"step" : @(action.step), @"handMac" : action.macAddress};
        [jsonStepsList addObject:actionDict];
    }

    // NSArray convert to Json
    NSString *jsonSteps = [jsonStepsList convertJson];
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.params = @{@"steps" : jsonSteps,
                       @"timestamp" : [VHSCommon getTimeStamp]};
    message.path = URL_ADD_STEP;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSArray *kmList = result[@"kmList"];
            // 更新本地数据库中的上传状态
            for (NSDictionary *kmDict in kmList) {
                [manager updateStatusToActionLst:kmDict[@"sportDate"] macAddress:[NSString stringWithFormat:@"%@", kmDict[@"handMac"]] distance:kmDict[@"km"]];
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

- (void)insertOrUpdateBleAction:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    [manager insertOrUpdateBleActionLst:action.actionId
                              member_id:action.memberId
                            action_mode:action.actionMode
                            action_type:action.actionType
                               distance:action.distance
                                seconds:action.seconds
                                calorie:action.calorie
                                   step:action.step
                             start_time:action.startTime
                               end_time:action.endTime
                            record_time:action.recordTime
                                  score:action.score
                                 upload:action.upload
                            mac_address:action.macAddress];
}

/// 更新运动步数
- (void)updateSportStep:(VHSActionData *)action {
    VHSDataBaseManager *manager = [VHSDataBaseManager shareInstance];
    [manager updateSportStepWithActionData:action];
}

@end
