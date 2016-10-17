//
//  CFunc.h
//  cdemo
//
//  Created by 张文广 on 16/3/2.
//  Copyright (c) 2016年 张文广. All rights reserved.
//


#ifndef __cdemo__CFunc__
#define __cdemo__CFunc__

#include <stdio.h>

uint32_t ProtocolLibcallBackTimerCrate();

uint32_t ProtocolLibcallBackTimerStart(uint32_t id,uint32_t timeOutMs);

uint32_t ProtocolLibcallBackTimerStop(uint32_t id);

extern uint32_t timer_ios_init(void);

int ProtocolLibTimerHandler(uint32_t id);
#pragma mark 发送命令数据
uint32_t ble_send_command_data(uint8_t *data,uint8_t length);

#pragma mark 发送健康数据
uint32_t ble_send_health_data(uint8_t *data,uint8_t length);
#pragma mark 设置时间
uint32_t ble_send_set_time();

#pragma mark 同步闹钟
uint32_t ble_send_sync__alarm();

#pragma mark 设置久坐
uint32_t ble_send_long_sit();

#pragma mark 设置防丢
uint32_t ble_send_lost_find();

#pragma mark 设置目标
uint32_t ble_send_goal();

#pragma mark 设置用户信息
uint32_t ble_send_set_userinfo();

#pragma mark 设置单位
uint32_t ble_send_set_uint();

#endif /* defined(__cdemo__CFunc__) */
