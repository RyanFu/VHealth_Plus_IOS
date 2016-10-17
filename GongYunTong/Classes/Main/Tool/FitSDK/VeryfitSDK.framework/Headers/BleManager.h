//
//  BleManager.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/4.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


typedef void(^BleManagerPeripherablock)(NSMutableArray *);
typedef void(^CallScanDeviceBack)(CBCentralManager *,CBPeripheral *,NSDictionary *,NSNumber *);
typedef void(^CallConnectStateBack)(BOOL,CBCentralManager *,CBPeripheral *,NSError *);
typedef void(^CallDisConnectStateBack)(CBCentralManager *,CBPeripheral *,NSError *);
typedef void(^BleManagerDidConnect)();
typedef void (^CallReConectBack)();
@interface BleManager : NSObject<CBCentralManagerDelegate>

@property (nonatomic,strong)  CBCentralManager *manager;

@property (nonatomic,copy) BleManagerPeripherablock peripherablock;

@property (nonatomic,copy) BleManagerDidConnect didconnectblock;

//蓝牙开关状态
@property (nonatomic,copy)void(^BleManagerState)(CBCentralManagerState);
//重连
@property (nonatomic,copy)CallReConectBack callReconect;
/*
 传回扫描到的设备
 */
@property (nonatomic,copy)CallScanDeviceBack callScanBlock;

/*
 传回连接状态
 */
@property (nonatomic,copy)CallConnectStateBack callConnectBack;

/*
 传回断开连接状态
 */
@property (nonatomic,copy)CallDisConnectStateBack callDisConnectBack;

//重连定时器
@property (nonatomic,strong)  NSTimer *timer;

//扫描
- (void)scanPeriphera;

//扫描正常设备
- (void)scanPeripheraWithoutUpdateService;

//停止扫描
- (void)stopScanPeriphera;


//断开连接
- (void)disconnect;

- (void)didCallScanDeviceBack:(CallScanDeviceBack)block;

- (void)didCallConnectStateBack:(CallConnectStateBack)block;

- (void)didCallDisConnectStateBack:(CallDisConnectStateBack)block;

- (void)Connect:(NSString *)uuidStr;

- (void)didCallReconect:(CallReConectBack)block;

@end
