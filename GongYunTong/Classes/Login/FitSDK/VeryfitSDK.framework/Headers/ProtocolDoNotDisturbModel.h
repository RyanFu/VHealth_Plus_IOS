//
//  ProtocolDoNotDisturbModel.h
//  SDKTestAppAiju
//
//  Created by aiju_huangjing1 on 16/5/24.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"
/*
 //防打扰
 struct protocol_do_not_disturb
 {
 struct protocol_head head;
 uint8_t switch_flag;
 uint8_t start_hour;
 uint8_t start_minute;
 uint8_t end_hour;
 uint8_t end_minute;
 };
 */
@interface ProtocolDoNotDisturbModel : JKDBModel
@property (nonatomic,copy)    NSString *smart_device_id;
@property (nonatomic,assign)  BOOL switch_flag;
@property (nonatomic,assign)  uint8_t start_hour;
@property (nonatomic,assign)  uint8_t start_minute;
@property (nonatomic,assign)  uint8_t end_hour;
@property (nonatomic,assign)  uint8_t end_minute;
@end
