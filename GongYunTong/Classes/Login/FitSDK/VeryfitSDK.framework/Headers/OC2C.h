//
//  OC2C.h
//  cdemo
//
//  Created by 张文广 on 16/3/2.
//  Copyright (c) 2016年 张文广. All rights reserved.
//

#include <stdio.h>


uint32_t TimerCrate();
uint32_t TimerStart(uint32_t id,double timeOutMs);
uint32_t TimerStop(uint32_t id);
uint32_t SendHealthData(uint8_t *data,uint8_t length);
uint32_t SendCommandData(uint8_t *data,uint8_t length);

uint32_t SendSetTime();
uint32_t SendSyncAlarm();
uint32_t SendSyncLongSit();
uint32_t SendSyncLostFind();
uint32_t SendSetGoal();
uint32_t SendSetUserInfo();
uint32_t  SendSetUint();