//
//  PeripheralModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/2.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeripheralModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger RSSI;
@property (nonatomic,copy) NSString *UUID;
//@property (nonatomic,strong) CBPeripheral *peripheral;

@end
