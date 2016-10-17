//
//  SharePeripheral.m
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/25.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "SharePeripheral.h"
#import "MBProgressHUD.h"

@interface SharePeripheral()<AsdkBleModuleDelegate>
{
    ASDKBleModule *asdkBleModule;
}
@end

@implementation SharePeripheral

static SharePeripheral*sharePeripheral = nil;

+ (SharePeripheral *)sharePeripheral{
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        sharePeripheral = [[self alloc] init];
    });
    return sharePeripheral;
}
- (id)init{
    self = [super init];
    if (self) {
        asdkBleModule  = [[ASDKBleModule alloc] init];
        self.bleName = [ShareDataSdk shareInstance].peripheral.name;
        asdkBleModule.delegate = self;
    }
    return self;
}

-(void)setSyscnTime:(NSString *)syscnTime {
    _syscnTime = syscnTime;
    if (![VHSCommon isNullString:syscnTime]) {
        [VHSCommon setShouHuanLastTimeSync:syscnTime];
        self.systimeLabel.text = [NSString stringWithFormat:@"最近一次获取手环数据：%@", syscnTime];
    }
}
- (NSString *)syscnTime {
    if (!_syscnTime) {
        NSString *time = [VHSCommon getShouHuanLastTimeSync];
        if (![VHSCommon isNullString:time]) {
            return time;
        }
        return nil;
    }
    return _syscnTime;
}
//发现服务
- (void)DiscoerService{
    [asdkBleModule ASDKSendDiscoverServices:[ShareDataSdk shareInstance].peripheral];
}

- (void)ASDKBLEManagerDisCoverServices:(BOOL)success Peripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (success) {
        for (CBService *service in peripheral.services)
        {
            NSLog(@"Service found with UUID: %@", service.UUID);  //查找特征
            [asdkBleModule ASDKSendDiscoverCharcristic:peripheral];
            
        }
    }
    else{
        NSLog(@"%@",@"获取失败哦");
    }
}

- (void)ASDKBLEManagerDisCoverCharacteristics:(BOOL)success Peripheral:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error{
    if (!self.needToJump) {
      [SharePeripheral sharePeripheral].callBackJump(peripheral);
    }
}
 
- (void)ASDKBLEManagerHaveReceivedData:(BOOL)success Peripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)charac error:(NSError *)error{
    if (success) {
        
       
    }
    else{
        NSLog(@"%@",@"获取失败");
    }
}
// 此方法是已经绑定手环，下次进入会调用此方法
//- (void)callBackReconect:(NSString *)uuidString{
//    _needBand = YES;
//    //加上这2句代码，防止多次连接设备 （多次弹出下个页面）   not by xulong 
//    CBPeripheral *peri=[ShareDataSdk shareInstance].peripheral;
//    if (peri && peri.state ==CBPeripheralStateConnecting) {
//        return;
//    }
//    [[SharePeripheral sharePeripheral].bleMolue ASDKSendConnectDevice:[[NSUserDefaults standardUserDefaults] objectForKey:@"lanya"]];
//    [SharePeripheral sharePeripheral].bleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"BLE_NAME"];
//    
//}
@end
