//
//  VHSPersonInfoController.h
//  GongYunTong
//
//  Created by ios-bert on 16/7/22.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailModel.h"

@interface VHSPersonInfoController : UIViewController <UIPickerViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UserDetailModel *detailModel;

@property (nonatomic, copy) void (^uploadHeadBlock)(NSString *headerUrl);
@property (nonatomic, copy) void (^updateNickNameBlock)(NSString *nickname);

@end
