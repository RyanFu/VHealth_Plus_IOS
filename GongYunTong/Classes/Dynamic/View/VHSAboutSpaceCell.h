//
//  VHSAboutSpaceCell.h
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 lucky. All rights reserved.
//

// 单图

#import <UIKit/UIKit.h>
#import "DynamicItemModel.h"

@interface VHSAboutSpaceCell : UITableViewCell

@property (nonatomic, strong) DynamicItemModel *dynamicItem;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
