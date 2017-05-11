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
+ (void)bleBindSuccessWith:(ShareDataSdk *)shareData;

//解绑成功
+ (void)bleUnbindSuccess;

//当前手环状态
+ (FitBLEState)nowBLEState;

@end
