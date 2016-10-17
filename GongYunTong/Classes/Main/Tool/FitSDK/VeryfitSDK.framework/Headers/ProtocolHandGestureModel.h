//
//  ProtocolHandGestureModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/29.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@interface ProtocolHandGestureModel : JKDBModel
@property (nonatomic,copy)NSString * smart_device_id;
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,assign) NSInteger showSecond;
@end
