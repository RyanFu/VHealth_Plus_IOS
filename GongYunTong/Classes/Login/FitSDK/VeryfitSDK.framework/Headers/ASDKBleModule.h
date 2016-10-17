//
//  ASDKBleModule.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/24.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//  蓝牙模块

/*
 - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
 */
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol AsdkBleModuleDelegate<NSObject>
@optional
- (void)ASDKBLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (void)ASDKBLEManagerConnectWithState:(BOOL)success andCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)ASDKBLEManagerDisConnectWithCBCentral:(CBCentralManager *)central didDisConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)ASDKBLEManagerDisCoverServices:(BOOL)success Peripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)ASDKBLEManagerDisCoverCharacteristics:(BOOL)success Peripheral:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error;

- (void)ASDKBLEManagerHaveReceivedData:(BOOL)success Peripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)charac error:(NSError *)error;

- (void)callBackBleManagerState:(CBCentralManagerState) powerState;
@required
- (void)callBackReconect:(NSString *)uuidString;



@end


#pragma mark 传回数据block
/*  传回数据block
 *
 *  object 传回数据模型或字符
 *  isSuccess 是否调用成功
 */
typedef void(^BLTAcceptModelUpdateValue)(id object, int errorCode);
@interface ASDKBleModule : NSObject
@property (nonatomic,copy) BLTAcceptModelUpdateValue updateBlock;

@property (nonatomic,weak) id<AsdkBleModuleDelegate>delegate;

@property (nonatomic,copy) void (^callFindServiceBack)(BOOL,CBPeripheral*,NSError*);

@property (nonatomic,copy) void (^callFindCharacsticBack)(BOOL,CBPeripheral*,CBService *,NSError*);
#pragma mark 连接设备
/*  连接设备
 *
 *  @param uuidStr 设备uuid
 */
- (void)ASDKSendConnectUpdateDevice:(CBPeripheral *)peripheral;

#pragma mark 扫描设备
/*  扫描设备
 *
 */
- (void)ASDKSendScanDevice;

#pragma mark 扫描正常状态设备
/*  扫描正常状态设备
 *
 */
- (void)ASDKSendScanDeviceWithoutUpdateService;

#pragma mark 停止扫描设备
/*  停止扫描设备
 *
 */
- (void)ASDKSendStopScanDevice;

#pragma mark 连接设备
/*  连接设备
 *
 *  @param uuidStr 设备uuid
 */
- (void)ASDKSendConnectDevice:(NSString *)uuidStr;

#pragma mark 断开连接设备
/*  断开连接设备
 *
 *  @param Peripheral 设备
 */
- (void)ASDKSendDisConnectDevice:(CBPeripheral *)Peripheral;

#pragma mark 重新连接设备
/*  重新连接设备
 *
 *  @param Peripheral 设备
 */
- (void)ASDKSendReConnectDevice:(CBPeripheral *)Peripheral;

#pragma mark 发现服务
/*  发现服务
 *
 *  @param Peripheral 设备
 */
- (void)ASDKSendDiscoverServices:(CBPeripheral *)Peripheral;

#pragma mark 发现特征
/*  发现特征
 *
 *  @param Peripheral 设备
 */
- (void)ASDKSendDiscoverCharcristic:(CBPeripheral *)Peripheral;

#pragma mark 监听特征
/*  监听特征
 *
 *  @param peripheral 监听执行者
 *  @param enabled 是否监听
 *  @param characteristic 要监听的特征
 */
- (void)ASDKSendNotice:(CBPeripheral *)peripheral NoticefyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic;

#pragma mark 向特征写入数据
/*  向特征写入数据
 *
 *  @param writeData要写入的数据
 *  @param type是否需要反应
 *  @param peripheral
 *  @param characteristic 写入数据的特征
 */
#pragma mark 写入数据
- (void)ASDKSendWriteData:(NSData *)writeData type:(CBCharacteristicWriteType)type Peripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)characteristic;


@end
