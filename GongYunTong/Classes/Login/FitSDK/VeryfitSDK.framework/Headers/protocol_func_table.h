/*
 * protocol_func_table.h
 *
 *  Created on: 2016年1月9日
 *      Author: Administrator
 */

#ifndef PROTOCOL_FUNC_TABLE_H_
#define PROTOCOL_FUNC_TABLE_H_

#include "include.h"
#include "protocol.h"

struct protocol_func_table_main
{
	bool stepCalculation;
	/** 睡眠监测 */
	bool sleepMonitor;
	/** 单次运动 */
	bool singleSport;
	/** 实时数据 */
	bool realtimeData;
	/** 设备更新 */
	bool deviceUpdate;
	/** 心率功能 */
	bool heartRate;
    
    bool Ancs;//通知中心
};

struct protocol_func_alarm_type
{
	// 闹钟提醒支持类型
	/** 起床 */
	bool wakeUp;
	/** 睡觉 */
	bool sleep;
	/** 锻炼 */
	bool sport;
	/** 吃药 */
	bool medicine;
	/** 约会 */
	bool dating;
	/** 聚会 */
	bool party;
	/** 会议 */
	bool metting;
	/** 自定义 */
	bool custom;

};


struct protocol_func_table_control
{
	 /** 拍照 */
	 bool takePhoto;
	 /** 音乐 */
	 bool music;

};

struct protocol_func_table_call
{
	 // 来电提醒功能
	 /** 来电提醒 */
	 bool calling;
	 /** 来电联系人 */
	 bool callingContact;
	 /** 来电号码 */
	 bool callingNum;

};

struct protocol_func_table_notify
{
	 // 信息提醒功能
	 /** 短信 */
	 bool message;
	 /** 邮件 */
	 bool email;
	 /** QQ */
	 bool qq;
	 /** 微信 */
	 bool weixin;
	 /** 新浪微博 */
	 bool sinaWeibo;
	 /** facebook */
	 bool facebook;
	 /** twitter */
	 bool twitter;

};

struct protocol_func_table_notify2
{
    bool whatsapp;
    bool messengre;
    bool instagram;
    bool linked_in;
};


struct protocol_func_table_other
{
	 // 其他功能
	 /** 久坐提醒 */
	 bool sedentariness;
	 /** 防丢提醒 */
	 bool antilost;
	 /** 一键呼叫 */
	 bool onetouchCalling;
	 /** 寻找手机 */
	 bool findPhone;
	 /** 寻找手环 */
	 bool findDevice;
     /*默认模式*/
     bool configDefault;
     /*手势*/
     bool upHandGesture;

};

struct protocol_func_table_ohter2
{
	/*静态心率*/
	bool staticHR;
	/*防打扰*/
	bool doNotDisturb;

	/*显示模式*/
	bool displayMode;

	/*心率监测*/
	bool heartRateMonitor;
};


struct protocol_func_table_sms
{
	// 信息提醒配置
	/** 提示信息联系人  */
	bool tipInfoContact;
	/** 提示信息号码  */
	bool tipInfoNum;
	/** 提醒信息内容  */
	bool tipInfoContent;
};


struct protocol_func_table
{
	struct protocol_func_table_main main; //主功能
	uint8_t alarm_count;                    //闹钟个数
	struct protocol_func_alarm_type type;   //支持闹钟类型
	struct protocol_func_table_control control; //控制功能
	struct protocol_func_table_call call;   //来电
	struct protocol_func_table_notify notify; //通知
    struct protocol_func_table_notify2 ontify2;
	struct protocol_func_table_other other; //其他
	struct protocol_func_table_sms sms; //短信息
	struct protocol_func_table_ohter2 ohter2; //其他2

};


#ifdef __cplusplus
extern "C" {
#endif

extern uint32_t protocol_func_table_init(void);
extern uint32_t protocol_func_table_set(struct protocol_get_func_table *protocol_data);
extern uint32_t protocol_func_table_get(struct protocol_func_table *table);
extern bool protocol_func_table_have_heart_rate(void);
extern uint8_t protocol_func_table_get_alarm_number(void);
    
#ifdef __cplusplus
}
#endif

#endif /* PROTOCOL_FUNC_TABLE_H_ */
