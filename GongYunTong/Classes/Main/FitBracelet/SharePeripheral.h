//
//  SharePeripheral.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/25.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <VeryfitSDK/VeryfitSDK.h>
#import "VHSSyscnTimeLabel.h"
@interface SharePeripheral : NSObject
{
    NSString *_syscnTime;
}
+ (SharePeripheral *)sharePeripheral;

@property (nonatomic,copy) void(^callBackJump)(CBPeripheral *);

@property (strong,nonatomic) ASDKBleModule *bleMolue;

@property (nonatomic,assign)BOOL needToJump;

@property (nonatomic,copy) NSString *heartRateBpm;

@property (nonatomic,copy) NSString *bleName;

@property(nonatomic,strong)VHSSyscnTimeLabel *systimeLabel;
@property (nonatomic,copy) NSString *syscnTime;
@property (nonatomic,strong) NSTimer *reconectTimer;

//发现服务
- (void)DiscoerService;
@end
