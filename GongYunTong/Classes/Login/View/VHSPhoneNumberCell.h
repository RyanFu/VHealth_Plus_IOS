//
//  VHSPhoneNumberCell.h
//  GongYunTong
//
//  Created by ios-bert on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHSForgetInfo.h"

@interface VHSPhoneNumberCell : UITableViewCell

@property (nonatomic, strong)VHSForgetInfo *model;

@property (nonatomic, copy) void (^callBack)(NSString *phoneNumber);

@end
