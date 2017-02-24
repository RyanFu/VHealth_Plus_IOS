//
//  VHSBraceletCoodinator.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/23.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSBraceletCoodinator.h"

@interface VHSBraceletCoodinator ()<AsdkBleModuleDelegate>

// 手环设备和和手机交互对象-用于扫描，停止扫描，连接，断开连接等操作
@property (nonatomic, strong, readonly) ASDKBleModule *bleModuleHandler;
// 手环设备设置对象-用语绑定，解绑
@property (nonatomic, strong, readonly) ASDKSetting *bleSettingHandler;

@property (nonatomic, copy, nullable) void (^scanBleCompletionHandler)(NSArray *braceletorList);

@property (nonatomic, strong) NSMutableArray *braceletorList;

@end

@implementation VHSBraceletCoodinator

+ (instancetype)shareBraceletCoodinator {
    static VHSBraceletCoodinator *braceletor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        braceletor = [[VHSBraceletCoodinator alloc] init];
        
        [braceletor startUpBraceletorOnce];
    });
    return braceletor;
}

#pragma mark - 手环SDK初始化，APP声明周期只一次

- (void)startUpBraceletorOnce {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    ASDKShareFunction *bleFunctor = [[ASDKShareFunction alloc] init];
#pragma clang diagnostic pop
    
    _bleModuleHandler = [[ASDKBleModule alloc] init];
    _bleSettingHandler = [[ASDKSetting alloc] init];
}

#pragma mark - 手环手机交互 - 扫描，停止扫描，连接，断开连接

- (void)scanBraceletorDuration:(NSTimeInterval)time completion:(void (^)(NSArray<VHSBraceletModel *> *braceletorList))completionHandler {
    self.scanBleCompletionHandler = completionHandler;
    self.bleModuleHandler.delegate = self;
    
    self.braceletorList = [[NSMutableArray alloc] init];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bleModuleHandler ASDKSendScanDevice];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time + 1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bleModuleHandler ASDKSendStopScanDevice];
    });
}

#pragma mark - 手环 - 绑定，解绑

- (void)bindBraceletorCompletion:(void (^)(int code))completionHandler {
    [self.bleSettingHandler ASDKSendDeviceBindingWithCMDType:ASDKDeviceBinding withUpdateBlock:^(int errorCode) {
        if (completionHandler) completionHandler(errorCode);
    }];
}

- (void)unbindBraceletorCompletion:(void (^)(int code))completionHandler {
    [self.bleSettingHandler ASDKSendDeviceBindingWithCMDType:ASDKDeviceUnbundling withUpdateBlock:^(int errorCode) {
        if (completionHandler) completionHandler(errorCode);
    }];
}


#pragma mark - AsdkBleModuleDelegate 手环连接手机操作代理回调

// require implemention
- (void)callBackReconect:(NSString *)uuidString {
    CLog(@"------>>> 1 ------>>> %@", uuidString);
}

- (void)ASDKBLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    CLog(@"------>>> 2 ------>>> %@ --->>>%@ --->>>%@ --->>>%@", central, peripheral, advertisementData, RSSI);
    if (self.scanBleCompletionHandler) self.scanBleCompletionHandler(self.braceletorList);
    
    if (labs([RSSI integerValue]) > 100 && ![advertisementData[@"kCBAdvDataLocalName"] length]) return;
    
    for (VHSBraceletModel *ble in self.braceletorList) {
        if ([peripheral.identifier.UUIDString isEqualToString:ble.UUID]) return;
    }
    
    VHSBraceletModel *ble = [[VHSBraceletModel alloc] init];
    ble.name = advertisementData[@"kCBAdvDataLocalName"];
    ble.UUID = peripheral.identifier.UUIDString;
    ble.RSSI = labs([RSSI integerValue]);
    [self.braceletorList addObject:ble];
    
    [self.braceletorList sortUsingComparator:^NSComparisonResult(VHSBraceletModel *obj1, VHSBraceletModel *obj2) {
        NSComparisonResult result = [[NSNumber numberWithInteger:obj1.RSSI] compare:[NSNumber numberWithInteger:obj2.RSSI]];
        return result;
    }];
}

- (void)ASDKBLEManagerConnectWithState:(BOOL)success andCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    CLog(@"------>>> 3 ------>>> %@ --->>>%@ --->>>%@ --->>>%@", @(success), central, peripheral, error);
}

- (void)ASDKBLEManagerDisConnectWithCBCentral:(CBCentralManager *)central didDisConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    CLog(@"------>>> 4 ------>>> %@ --->>>%@ --->>>%@", central, peripheral, error);
}

- (void)ASDKBLEManagerDisCoverServices:(BOOL)success Peripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    CLog(@"------>>> 5 ------>>> %@ --->>>%@ --->>>%@", @(success), peripheral, error);
}

- (void)ASDKBLEManagerDisCoverCharacteristics:(BOOL)success Peripheral:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error {
    CLog(@"------>>> 6 ------>>> %@ --->>>%@ --->>>%@", @(success), service, error);
}

- (void)ASDKBLEManagerHaveReceivedData:(BOOL)success Peripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)charac error:(NSError *)error {
    CLog(@"------>>> 7 ------>>> %@ --->>>%@ --->>>%@ --->>>%@", @(success), peripheral, charac, error);
}

- (void)callBackBleManagerState:(CBCentralManagerState) powerState {
    CLog(@"------>>> 8 --->>> %@", @(powerState));
}


@end
