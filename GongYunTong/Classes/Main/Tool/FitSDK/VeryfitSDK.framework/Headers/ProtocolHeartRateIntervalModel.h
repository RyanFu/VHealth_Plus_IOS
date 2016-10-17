//
//  ProtocolHeartRateIntervalModel.h
//  SDKTestAppAiju
//
//  Created by aiju_huangjing1 on 16/5/24.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolHeartRateIntervalModel : JKDBModel
@property (nonatomic,copy) NSString *smart_device_id;
/*
 uint8_t burn_fat_threshold;
 uint8_t aerobic_threshold;
 uint8_t limit_threshold;
 */
@property (nonatomic,assign) uint8_t burn_fat_threshold;
@property (nonatomic,assign) uint8_t aerobic_threshold;
@property (nonatomic,assign) uint8_t limit_threshold;
@end
