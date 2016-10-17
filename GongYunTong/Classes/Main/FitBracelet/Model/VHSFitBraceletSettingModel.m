//
//  VHSFitBraceletSettingModel.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/28.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSFitBraceletSettingModel.h"

@implementation VHSFitBraceletSettingModel


+(instancetype)settingModelWithImage:(NSString *)settinImage operation:(NSString *)settingOperation operationDetail:(NSString *)settingOperationDetail
{
    VHSFitBraceletSettingModel *model=[[VHSFitBraceletSettingModel alloc]init];
    model.settingImage=settinImage;
    model.settingOperation=settingOperation;
    model.settingOperationDetail=settingOperationDetail;
    return model;
}
@end
