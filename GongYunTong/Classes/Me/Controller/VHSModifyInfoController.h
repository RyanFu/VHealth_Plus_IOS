//
//  VHSModifyInfoController.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSBaseViewController.h"

typedef NS_ENUM(NSInteger, VHSModifyInfoType)
{
    VHSModifyInfoNormalType,
    VHSModifyInfoMobileType
};

typedef NS_ENUM(NSInteger, VHSCellType){
    VHSCellNickNameType,
    VHSCellMobileType,
    VHSCellEmailType
};

@interface VHSModifyInfoController : VHSBaseViewController

@property (nonatomic, assign) VHSModifyInfoType modifyType;
@property (nonatomic, assign) VHSCellType cellType;

@property (nonatomic, copy) void (^callBack)(id str);

@property (nonatomic, strong) NSString *contentStr;

@property (nonatomic, strong) NSMutableDictionary *contentDict;         // 用于传入数据和回调数据

@end
