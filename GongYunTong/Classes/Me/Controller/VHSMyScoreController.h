//
//  VHSMyScoreController.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSBaseViewController.h"
#import "UserScoreModel.h"

@interface VHSMyScoreController : VHSBaseViewController

@property (nonatomic, strong) UserScoreModel *scoreModel;
@property (nonatomic, copy) void (^myscoreCallBack)(UserScoreModel *scoreModel); // 我的积分回调->我

@end
