//
//  VHSModifyMobileCell.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ModifyType){
    ModifyPhoneType,
    ModifyAuthCodeType
};

@interface VHSModifyMobileCell : UITableViewCell

@property (nonatomic, assign) ModifyType modifyType;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *contentStr;

@property (nonatomic, copy) void (^callback)(NSString *destStr);

@property (nonatomic, copy) void (^operateBlock)(NSString *destStr);

@end
