//
//  PeripheraInstance.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/2.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void (^CallDidDiscoverServices)(BOOL,CBPeripheral *,NSError *);
typedef void (^CallDidDiscoverCharacteristicsForService)(BOOL,CBPeripheral *,CBService *,NSError *);
typedef void (^CallDidReceivedDataFromBle)(BOOL,CBPeripheral *,CBCharacteristic *,NSError *);


@interface PeripheraInstance : NSObject<CBPeripheralDelegate>

///*  peripheralNew
// *
// *  连接的设备，目前是单例，唯一的
// */
//@property (nonatomic,strong) CBPeripheral *peripheralNew;
//@property (nonatomic,strong) CBCharacteristic *charCmdTx;
//@property (nonatomic,strong) CBCharacteristic *charHealthTx;
//
//@property (nonatomic, assign) CBCharacteristicWriteType writeType;

/*
 传回服务
 */
@property (nonatomic,copy) CallDidDiscoverServices discoverServicesBlock;

/*
 传回特征
 */
@property (nonatomic,copy) CallDidDiscoverCharacteristicsForService discoverCharacteristics;

/*
 传回接收到的数据
 */
@property (nonatomic,copy) CallDidReceivedDataFromBle receivedDataBlock;


- (void)discoverServicesBack:(CallDidDiscoverServices)block;

- (void)discoverCharacteristicsBack:(CallDidDiscoverCharacteristicsForService)block;

- (void)didReceivedDataFromBle:(CallDidReceivedDataFromBle)block;
@end
