//
//  VHSFitBraceletSettingModel.h
//  VHealth1.6
//
//  Created by vhsben on 16/6/28.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSFitBraceletSettingModel : NSObject

@property (nonatomic,copy) NSString *settingImage;               //左侧图片
@property (nonatomic,copy) NSString *settingOperation;           //设置的操作
@property (nonatomic,copy) NSString *settingOperationDetail;     //设置操作描述

- (instancetype)initWithImageName:(NSString *)imgName settingOperation:(NSString *)settingOperation operationTime:(NSString *)operationTime;

@end
