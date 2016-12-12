//
//  VHSDynamicConfigurationCell.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/7.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconItem.h"

@interface VHSDynamicConfigurationCell : UITableViewCell

// icon按钮回调
@property (nonatomic, copy) void (^iconCallBack)(IconItem *iconItem);
@property (nonatomic, strong) NSArray *configurationList;;

@end


@interface IconConfigurationBtn : UIButton

@property (nonatomic, strong) IconItem *iconItem;

@end
