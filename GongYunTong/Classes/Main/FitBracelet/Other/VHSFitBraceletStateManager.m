//
//  VHSFitBraceletState.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/30.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSFitBraceletStateManager.h"

@implementation VHSFitBraceletStateManager


//绑定成功
+(void)BLEbindSuccessWithBLEName:(NSString *)name UUID:(NSString *)UUID macAddress:(NSString *)macAddr {
    [k_UserDefaults setObject:name forKey:k_SHOUHUAN_NAME];
    [k_UserDefaults setObject:UUID forKey:k_SHOUHUAN_UUID];
    [k_UserDefaults setObject:macAddr forKey:k_SHOUHUAN_MAC_ADDRESS];
    [k_UserDefaults setObject:[VHSCommon getDate:[NSDate date]] forKey:k_SHOUHUAN_BOUND_TIME];
    [k_UserDefaults setObject:[VHSCommon getDate:[NSDate date]] forKey:k_SHOUHUAN_LAST_TIME_SYNC]; // 绑定时为最新同步时间
    [k_UserDefaults setBool:YES forKey:k_SHOUHUAN_IS_BIND];
    [k_UserDefaults synchronize];
}
//绑定失败 （清除UUID）
+(void)BLEbindFail
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_SHOUHUAN_UUID];
}
//解绑成功
+(void)BLEUnbindSuccess {
    [k_UserDefaults removeObjectForKey:k_SHOUHUAN_NAME];
    [k_UserDefaults removeObjectForKey:k_SHOUHUAN_UUID];
    [k_UserDefaults removeObjectForKey:k_SHOUHUAN_MAC_ADDRESS];
    [k_UserDefaults setBool:NO forKey:k_SHOUHUAN_IS_BIND];
    [k_UserDefaults setObject:@(0) forKey:k_SHOUHUAN_LAST_STEPS_SYNC];
    //保存手环解绑时间
    [k_UserDefaults setObject:[VHSCommon getDate:[NSDate date]] forKey:k_SHOUHUAN_UNBING_TIME];
    // 解绑－初始化解绑同步时间
    [k_UserDefaults setObject:[VHSCommon getDate:[NSDate date]] forKey:k_M7_MOBILE_SYNC_TIME];
    [k_UserDefaults synchronize];
}

//当前手环状态
+(FitBLEState)nowBLEState {
    
    NSString *mac_address = [k_UserDefaults objectForKey:k_SHOUHUAN_MAC_ADDRESS];
    NSString *uuid = [k_UserDefaults objectForKey:k_SHOUHUAN_UUID];
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
