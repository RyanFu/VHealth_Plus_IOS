//
//  VHSRecordStepController.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSBaseViewController.h"

@interface VHSRecordStepController : VHSBaseViewController

@property (nonatomic, assign) NSInteger sumSteps;       // 连接手机或者手环后的总步数
@property (nonatomic, copy) void (^callback)(NSInteger steps);

@end
