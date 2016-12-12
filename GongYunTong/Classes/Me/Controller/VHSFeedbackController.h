//
//  VHSFeedbackController.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSBaseViewController.h"

@interface VHSFeedbackController : VHSBaseViewController

@property (nonatomic, strong) NSMutableDictionary *feedbackDict;

@property (nonatomic, copy) void (^callBack)(NSMutableDictionary *descDict);

@end
