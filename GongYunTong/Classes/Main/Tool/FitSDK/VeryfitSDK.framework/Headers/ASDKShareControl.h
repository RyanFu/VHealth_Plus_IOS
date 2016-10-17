//
//  ASDKShareControl.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/30.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "protocol_func_table.h"
#import "CFunc.h"
#import "OCClass.h"
#import "protocol.h"
#import "app_timer.h"
#import "Protocol_ios.h"
#import "Protocol_ios_port.h"
#import "ProtocolSportDataModel.h"
#import "ProtocolSleepDataModel.h"
#import "ProtocolHeartRateModel.h"
#import "ProtocolSetAlarmModel.h"
#import "ShareDataSdk.h"
#import "ASDKDeviceEnum.h"


@interface ASDKShareControl : NSObject
#pragma mark customMethods
+ (void)getDeviceInfoWith:(void *)data;
+ (void)getMacAddressWith:(void *)data;
- (void)getFuncTableWith:(struct protocol_func_table *)data;
+ (void)getLiveDataWith:(void *)data;
+ (void)Protocol_ios_vbusWith:(VBUS_EVT_BASE) evt_base and:(VBUS_EVT_TYPE) evt_type andData:(void *)data andSize:(uint32_t) size andRetCode:(uint32_t *)error_code;

+ (void)updateUserIdAboutSDKWith:(NSString *)user_id;
@end
