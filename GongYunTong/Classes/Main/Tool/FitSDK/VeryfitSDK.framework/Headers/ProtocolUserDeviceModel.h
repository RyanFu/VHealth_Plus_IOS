//
//  ProtocolUserDeviceModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/6.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"


@interface ProtocolUserDeviceModel : JKDBModel
@property (nonatomic,copy)   NSString *user_id;
@property (nonatomic,copy)   NSString *mac_address;
@property (nonatomic,copy)   NSString *smart_device_id;
@property (nonatomic,assign) BOOL     band_status;



@end
