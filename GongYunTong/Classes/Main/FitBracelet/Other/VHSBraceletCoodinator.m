//
//  SharePeripheral.m
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/25.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "VHSBraceletCoodinator.h"
#import "VHSStepAlgorithm.h"
#import "VHSFitBraceletStateManager.h"

@interface VHSBraceletCoodinator()<AsdkBleModuleDelegate>

@property (nonatomic, strong) NSMutableArray<PeripheralModel *> *peripherals;
// 扫描结束成功回调 - 多次，每扫描到一个设备，回调一次
@property (nonatomic, copy, nonnull) void (^scanBleCompletionHandler)(NSArray *braceletorList);

@end

@implementation VHSBraceletCoodinator

static VHSBraceletCoodinator *sharePeripheral = nil;

+ (VHSBraceletCoodinator *)sharePeripheral {
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        sharePeripheral = [[self alloc] init];
        
        [sharePeripheral startUpBraceletorResourceOnce];
    });
    return sharePeripheral;
}

// 初始初始化手环SDK
- (void)startUpBraceletorResourceOnce {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    ASDKShareFunction *asdk = [[ASDKShareFunction alloc] init];
#pragma clang diagnostic pop
    
    _bleMolue = [[ASDKBleModule alloc] init];
    _bleMolue.delegate = self;
    
    _bleHandringDataer = [[ASDKGetHandringData alloc] init];
    _bleSetter = [[ASDKSetting alloc] init];
}


- (NSString *)recentlySyncTime {
    NSString *recentlyTime = [VHSCommon getShouHuanLastTimeSync];
    if (![VHSCommon isNullString:recentlyTime]) {
        return recentlyTime;
    }
    return @"";
}

#pragma mark - 手环操作

- (void)scanBraceletorDuration:(NSTimeInterval)time process:(void (^)())processHandler completion:(void (^)(NSArray<PeripheralModel *> *braceletorList))completionHandler {
    // 绑定手环前先断开手环连接信息
    [[VHSBraceletCoodinator sharePeripheral] disconnectBraceletorWithPeripheral:[ShareDataSdk shareInstance].peripheral];
    
    self.peripherals = [NSMutableArray new];
    self.scanBleCompletionHandler = completionHandler;
    
    if (processHandler) processHandler();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bleMolue ASDKSendScanDevice];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bleMolue ASDKSendStopScanDevice];
    });
}

- (void)connectBraceletorWithBleUUID:(NSString *)uuid {
    if (!uuid) return;
    
    [self.bleMolue ASDKSendConnectDevice:uuid];
}

- (void)disconnectBraceletorWithPeripheral:(CBPeripheral *)peripheral {
    if (!peripheral) return;
    [self.bleMolue ASDKSendDisConnectDevice:peripheral];
}

#pragma mark - 手环数据获取

- (void)getBraceletorDeviceInfoWithCallback:(BLEDataAcceptCallBack)deviceInfoBlock {
    [self.bleHandringDataer ASDKSendGetDeviceInfoWithUpdateBlock:^(id object, int errorCode) {
        if (deviceInfoBlock) deviceInfoBlock(object, errorCode);
    }];
}

- (void)getBraceletorSendSportDataForThedayWithCallBack:(BLEDataAcceptCallBack)resultBlock {
    [self.bleHandringDataer ASDKSendRequestSportDataForTodayWithUpdateBlock:^(id object, int errorCode) {
        if (resultBlock) resultBlock(object, errorCode);
    }];
}

- (ProtocolSportDataModel *)getBraceletorSportBySpecifiedDay:(NSString *)specifiedDay andHandMac:(NSString *)macAddress {
    return [self.bleHandringDataer ASDKSendGetSportData:specifiedDay AndDevicePkId:macAddress];
}

- (void)getBraceletorRealtimeDataWithCallBack:(BLEDataAcceptCallBack)resultBlock {
    [self.bleHandringDataer ASDKSendDataToAcceptRealTimeDataWithUpdateBlock:^(id object, int errorCode) {
        if (resultBlock) resultBlock(object, errorCode);
    }];
}

#pragma mark - 手环绑定-解绑

- (void)braceletorGotoBindWithCallBack:(void (^)(int errorCode))resultBlock {
    [self.bleSetter ASDKSendDeviceBindingWithCMDType:ASDKDeviceBinding withUpdateBlock:^(int errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultBlock) resultBlock(errorCode);
        });
    }];
}

- (void)braceletorGotoUnbindWithCallBack:(void (^)(int errorCode))resultBlock {
    [self.bleSetter ASDKSendDeviceBindingWithCMDType:ASDKDeviceUnbundling withUpdateBlock:^(int errorCode) {
        // 断开设备与手环的链接
        while ([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected) {
            [[VHSBraceletCoodinator sharePeripheral] disconnectBraceletorWithPeripheral:[ShareDataSdk shareInstance].peripheral];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultBlock) resultBlock(errorCode);
        });
    }];
}

#pragma mark - 手环代理-AsdkBleModuleDelegate

// 扫描到外围手环设备回调
- (void)ASDKBLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (ABS([RSSI integerValue]) > 100 || ![advertisementData[@"kCBAdvDataLocalName"] length]) {
        return;
    }
    
    for (PeripheralModel *pm in self.peripherals) {
        if ([pm.UUID isEqualToString:peripheral.identifier.UUIDString]) {
            return;
        }
    }
    
    PeripheralModel *model = [[PeripheralModel alloc] init];
    model.UUID = peripheral.identifier.UUIDString;
    model.RSSI = ABS([RSSI integerValue]);
    model.name = advertisementData[@"kCBAdvDataLocalName"];
    [self.peripherals addObject:model];
    
    [self.peripherals sortUsingComparator:^NSComparisonResult(PeripheralModel *obj1, PeripheralModel *obj2) {
        NSComparisonResult result = [[NSNumber numberWithInteger:obj1.RSSI] compare:[NSNumber numberWithInteger:obj2.RSSI]];
        return result;
    }];
    
    if (self.scanBleCompletionHandler) self.scanBleCompletionHandler(self.peripherals);
}

// 连接外围手环设备回调
- (void)ASDKBLEManagerConnectWithState:(BOOL)success andCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (success) {
        [[VHSBraceletCoodinator sharePeripheral].bleMolue ASDKSendDiscoverServices:peripheral];
        if (peripheral.state == CBPeripheralStateConnected) {
            // 本地保存手环连接时间
            [VHSCommon setShouHuanConnectedTime:[VHSCommon getYmdFromDate:[NSDate date]]];
            [self upToDateBraceletData];
        }
    } else {
        CLog(@"连接失败：%@",error);
    }
}

// 断开外围手环设备回调
- (void)ASDKBLEManagerDisConnectWithCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    CLog(@"--->>> 断开手环和手机的连接");
}

// 发现外围设备的服务
- (void)ASDKBLEManagerDisCoverServices:(BOOL)success Peripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (success) {
        // 根据外围服务去查找特征
        [[VHSBraceletCoodinator sharePeripheral].bleMolue ASDKSendDiscoverCharcristic:peripheral];
    } else {
        CLog(@"---->>> 发现外围服务失败");
    }
}

// 发现外围服务特征 - 绑定手环时候会回调
- (void)ASDKBLEManagerDisCoverCharacteristics:(BOOL)success Peripheral:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error{
    if (!success) return;
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {
        //绑定且连接状态
        CLog(@"手环链接－－－并且已经绑定");
        // 证明 - 已经绑定过手环
        NSString *mac = [k_UserDefaults objectForKey:k_SHOUHUAN_MAC_ADDRESS];
        [ShareDataSdk shareInstance].smart_device_id = mac;
    } else {
        CLog(@"手环链接－－－未绑定  macid====%@",[ShareDataSdk shareInstance].smart_device_id);
    }
    
    [k_NotificationCenter postNotificationName:DeviceDidConnectedBLEsNotification object:nil userInfo:@{DeviceDidConnectedBLEsUserInfoPeripheral : peripheral}];
}

/// 外围设备和手机数据交互回调
- (void)ASDKBLEManagerHaveReceivedData:(BOOL)success Peripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)charac error:(NSError *)error{
    if (success) {
        CLog(@"手环-手机数据信息--交互成功");
    } else {
        CLog(@"手环-手机数据信息--交互失败");
    }
}

// 判断蓝牙是否开启
- (void)callBackBleManagerState:(CBCentralManagerState)powerState {
    // 开启蓝牙
    if (CBCentralManagerStatePoweredOn == powerState) {
        self.blueToothState = CBManagerStatePoweredOn;
    }
    // 蓝牙关闭
    else if (CBCentralManagerStatePoweredOff == powerState) {
        self.blueToothState = CBManagerStatePoweredOff;
        
        CBPeripheral *peripheral = [ShareDataSdk shareInstance].peripheral;
        [[VHSBraceletCoodinator sharePeripheral] disconnectBraceletorWithPeripheral:peripheral];
    }
}

// 此方法是已经绑定手环，下次进入会调用此方法
- (void)callBackReconect:(NSString *)uuidString{
    //加上这2句代码，防止多次连接设备
    CBPeripheral *peripheral = [ShareDataSdk shareInstance].peripheral;
    if (peripheral.state == CBPeripheralStateConnected) {
        return;
    }
    
    NSString *uuid = [k_UserDefaults objectForKey:k_SHOUHUAN_UUID];
    NSString *name = [k_UserDefaults objectForKey:k_SHOUHUAN_NAME];
    if ([VHSCommon isNullString:uuid]) {
        [[VHSBraceletCoodinator sharePeripheral].bleMolue ASDKSendDisConnectDevice:[ShareDataSdk shareInstance].peripheral];
        return;
    }
    
    [[VHSBraceletCoodinator sharePeripheral].bleMolue ASDKSendConnectDevice:uuid];
    [VHSBraceletCoodinator sharePeripheral].bleName = name;
}

#pragma mark - 蓝牙状态切换后同步手环数据
///  同步手环数据
- (void)upToDateBraceletData {
    [[VHSStepAlgorithm shareAlgorithm] asynDataFromBraceletToMobileDB:^{
        [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:nil];
        [k_NotificationCenter postNotificationName:k_NOTI_SYNCSTEPS_TO_NET object:self];
    }];
}



@end
