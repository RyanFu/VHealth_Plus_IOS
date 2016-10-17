//
//  ProtocolSetLongSitModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/22.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@interface ProtocolSetLongSitModel : JKDBModel

@property (nonatomic,copy) NSString *start_hour; //开始时间
@property (nonatomic,copy) NSString *start_minute;
@property (nonatomic,copy) NSString *end_hour; //   结束时间
@property (nonatomic,copy) NSString *end_minute;
@property (nonatomic,copy) NSString *interval;
@property (nonatomic,copy) NSString *repetitions; //重复
@property (nonatomic,assign) BOOL isOpen; //是否打开
@property (nonatomic,strong) NSArray *selectArray;//选中重复的星期

@property (nonatomic,copy) NSString *smart_device_id;
@end
