//
//  ProtocolFindPhoneModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/20.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolFindPhoneModel : JKDBModel
@property (nonatomic,assign) BOOL is_open;

@property (nonatomic,copy) NSString *smart_device_id;
@end
