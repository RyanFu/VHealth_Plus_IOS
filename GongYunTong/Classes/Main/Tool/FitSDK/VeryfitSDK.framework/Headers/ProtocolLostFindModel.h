//
//  ProtocolLostFindModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/22.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

typedef enum {
     NoneLostFind =0, //未开启防丢模式
     FarLostFind,//远距离防丢模式
     CloseLostFind,//近距离防丢模式
     MiddleLostFind//中距离防丢模式
}LostFindType;

@interface ProtocolLostFindModel : JKDBModel
@property (nonatomic,assign) LostFindType lost_type;

@property (nonatomic,copy) NSString *smart_device_id;
@end
