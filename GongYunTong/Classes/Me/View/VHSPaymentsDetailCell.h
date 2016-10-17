//
//  VHSPaymentsDetailCell.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceItemModel.h"

@interface VHSPaymentsDetailCell : UITableViewCell

@property (nonatomic, assign) BOOL shouldHiddenLine;

@property (nonatomic, strong) BalanceItemModel *balanceItem;

@end
