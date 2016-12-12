//
//  VHSNormalCell.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeSumScoreModel.h"

@interface VHSNormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (nonatomic, assign) BOOL shouldHiddenLine;

@end
