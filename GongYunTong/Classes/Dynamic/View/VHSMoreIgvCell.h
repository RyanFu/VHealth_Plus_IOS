//
//  VHSMoreIgvCell.h
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicItemModel.h"

@interface VHSMoreIgvCell : UITableViewCell

@property (nonatomic, strong) DynamicItemModel *dynamicItem;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
