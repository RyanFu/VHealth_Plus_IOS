//
//  ShareDataSdk.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/21.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleManager.h"
#import "protocol_data.h"
@interface ShareDataSdk : NSObject



+ (ShareDataSdk *)shareInstance;

@property (nonatomic,copy) NSString *uuidString;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *smart_device_id;

@property (nonatomic,assign) NSInteger alarmCount;

@property (nonatomic,strong) BleManager *bleMAnager;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) CBCharacteristic *charCmdTx;
@property (nonatomic,strong) CBCharacteristic *charHealthTx;
@property (nonatomic, assign) CBCharacteristicWriteType writeType;




@property (nonatomic,assign) BOOL noAutoConnect;

- (PROTOCOL_MODE )getCurrentMode;
- (BOOL)setProtocolMode:(PROTOCOL_MODE)mode;
@end
