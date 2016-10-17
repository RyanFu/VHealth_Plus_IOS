//
//  OCClass.h
//  cdemo
//
//  Created by 张文广 on 16/3/2.
//  Copyright (c) 2016年 张文广. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCClass : NSObject
+ (OCClass *)shareOCClass;
#pragma mark 定时器数组
@property (nonatomic,strong) NSMutableArray *timerArray;
#pragma mark 已启动的定时器数组
@property (nonatomic,strong) NSMutableArray *startArray;

- (int)timerCreate;
- (int)timerStart:(NSInteger)idInt timeOut:(double)timeOut;
- (int)timerStop:(NSInteger)idInt;

#pragma mark 发送数据
- (void)sendHealthDataWith:(uint8_t*)data length:(uint8_t)theLength;
- (void)sendCommandDataWith:(uint8_t*)data length:(uint8_t)theLength;

#pragma mark C库回调设置时间
- (void)DeviceSetTime;

#pragma mark C库同步闹钟
- (void)DeviceSyncAlarm;

#pragma mark C库设置就做提醒
- (void)DeviceSetLongSit;

#pragma mark C库设置防丢
- (void)DeviceSetLostFind;

#pragma mark 设置目标
- (void)DeviceSendSetGoal;

#pragma mark 设置用户信息
- (void)DeviceSendSetUserInfo;

#pragma mark 设置单位
- (void)DeviceSendSetUint;
@end
