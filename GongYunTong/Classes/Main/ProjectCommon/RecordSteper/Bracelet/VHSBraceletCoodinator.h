//
//  SharePeripheral.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/25.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <VeryfitSDK/VeryfitSDK.h>

typedef void(^BLEDataAcceptCallBack)(id object, int errorCode);

@interface VHSBraceletCoodinator : NSObject

+ (VHSBraceletCoodinator *)sharePeripheral;

@property (nonatomic, strong, readonly) ASDKBleModule *bleMolue;
@property (nonatomic, strong, readonly) ASDKGetHandringData *bleHandringDataer;
@property (nonatomic, strong, readonly) ASDKSetting *bleSetter;

@property (nonatomic, strong) NSString *bleName;
@property (nonatomic, strong) NSString *recentlySyncTime;
@property (nonatomic, assign) CBManagerState blueToothState; // 手机蓝牙状态

#pragma mark - 手环行为交行-连接，断开连接
/// 手环扫描
- (void)scanBraceletorDuration:(NSTimeInterval)time process:(void (^)())processHandler completion:(void (^)(NSArray<PeripheralModel *> *braceletorList))completionHandler;
/// 连接手环
- (void)connectBraceletorWithBleUUID:(NSString *)uuid;
/// 断开手环连接
- (void)disconnectBraceletorWithPeripheral:(CBPeripheral *)peripheral;

#pragma mark - 手环数据交互
/// 获取手环设备信息
- (void)getBraceletorDeviceInfoWithCallback:(BLEDataAcceptCallBack)deviceInfoBlock;
/*  获取全部运动和睡眠数据
 *
 *  @param block 传回数据 object 为运动数据数组 @[SpoerArr,SleepArray] 结构
 */
- (void)getBraceletorSendSportDataForThedayWithCallBack:(BLEDataAcceptCallBack)resultBlock;
/// 获取手环所有数据
- (void)getBraceletorGetAllHealthDataWithCallBack:(BLEDataAcceptCallBack)resultBlock;
/// 获取指定一天手环的运动步数
- (ProtocolSportDataModel *)getBraceletorSportBySpecifiedDay:(NSString *)specifiedDay andHandMac:(NSString *)macAddress;
/// 获取手环实时数据 - object为ProtocolLiveDataModel类型
- (void)getBraceletorRealtimeDataWithCallBack:(BLEDataAcceptCallBack)resultBlock;

#pragma mark - 手环绑定-解绑
/// 绑定手环
- (void)braceletorGotoBindWithCallBack:(void (^)(int errorCode))resultBlock;
/// 手环解绑
- (void)braceletorGotoUnbindWithCallBack:(void (^)(int errorCode))resultBlock;
@end
