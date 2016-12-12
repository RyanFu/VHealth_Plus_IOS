//
//  VHSScanBraceletController.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/9.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSBaseViewController.h"
#import "VHSRecordStepController.h"

@interface VHSScanBraceletController : VHSBaseViewController

@property (nonatomic, strong) VHSRecordStepController * topVC;

@property (nonatomic, copy) void (^getDataBaseDataBlock)();

@end
