//
//  VHSFitBraceletState.h
//  VHealth1.6
//
//  Created by vhsben on 16/6/30.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, FitBLEState) {
    FitBLEStateDisbind = 0,                         // 未绑定
    FitBLEStatebindDisConnected,                    //已绑定未连接
    FitBLEStatebindConnected,                       //已绑定已连接
};

@interface VHSFitBraceletStateManager : NSObject

//绑定成功
+(void)BLEbindSuccessWithBLEName:(NSString *)name UUID:(NSString *)UUID macAddress:(NSString *)macAddr;

//绑定失败 （清除UUID）
+(void)BLEbindFail;
//解绑成功
+(void)BLEUnbindSuccess;

//当前手环状态
+(FitBLEState)nowBLEState;

@end
