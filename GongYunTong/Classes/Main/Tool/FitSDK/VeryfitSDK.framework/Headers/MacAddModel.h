//
//  MacAddModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/15.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "protocol.h"

@interface MacAddModel : NSObject
/*
 *MacArray mac地址数组 MacString MAC地址字符串
 */
@property (nonatomic,strong) NSArray *MacArray;
@property (nonatomic,copy) NSString *MacString;

- (id)initWith:(struct protocol_device_mac )mac;

@end
