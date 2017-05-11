//
//  VHSFitBraceletState.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/30.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSFitBraceletStateManager.h"

@implementation VHSFitBraceletStateManager

+ (void)bleBindSuccessWith:(ShareDataSdk *)shareData {
    [VHSCommon saveUserDefault:shareData.peripheral.name forKey:k_SHOUHUAN_NAME];
    [VHSCommon saveUserDefault:shareData.uuidString forKey:k_SHOUHUAN_UUID];
    [VHSCommon saveUserDefault:shareData.smart_device_id forKey:k_SHOUHUAN_MAC_ADDRESS];
    [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]] forKey:k_SHOUHUAN_BOUND_TIME];
}

//解绑成功
+ (void)bleUnbindSuccess {
    [VHSCommon removeUserDefaultForKey:k_SHOUHUAN_NAME];
    [VHSCommon removeUserDefaultForKey:k_SHOUHUAN_UUID];
    [VHSCommon removeUserDefaultForKey:k_SHOUHUAN_MAC_ADDRESS];
    [VHSCommon saveUserDefault:[VHSCommon getDate:[NSDate date]] forKey:k_M7_MOBILE_SYNC_TIME];
}

//当前手环状态
+ (FitBLEState)nowBLEState {
    
    NSString *mac_address = [VHSCommon getUserDefautForKey:k_SHOUHUAN_MAC_ADDRESS];
    NSString *uuid = [VHSCommon getUserDefautForKey:k_SHOUHUAN_UUID];
    
    if (![VHSCommon isNullString:mac_address] && ![VHSCommon isNullString:uuid]) {
        //存在name和uuid
        if ([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected) {
            //已经连接状态
            return FitBLEStatebindConnected;
        } else {
            return FitBLEStatebindDisConnected;
        }
    } else {
        return FitBLEStateDisbind;
    }
}

@end
