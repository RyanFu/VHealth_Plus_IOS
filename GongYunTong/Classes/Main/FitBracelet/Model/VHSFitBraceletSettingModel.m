//
//  VHSFitBraceletSettingModel.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/28.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSFitBraceletSettingModel.h"

@implementation VHSFitBraceletSettingModel

- (instancetype)initWithImageName:(NSString *)imgName settingOperation:(NSString *)settingOperation operationTime:(NSString *)operationTime {
    self = [super init];
    if (!self) return nil;
    
    _settingImage = imgName;
    _settingOperation = settingOperation;
    _settingOperationDetail = operationTime;
    
    return self;
}


@end
