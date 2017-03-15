//
//  VHSSettingBraceletCell.h
//  VHealth1.6
//
//  Created by vhsben on 16/6/28.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VHSFitBraceletSettingModel;

@interface VHSSettingBraceletCell : UITableViewCell


@property(nonatomic,strong)VHSFitBraceletSettingModel *model;
@property(nonatomic)BOOL isDisBinding;  //正在解绑


@end
