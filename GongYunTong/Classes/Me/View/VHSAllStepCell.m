//
//  VHSAllStepCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/17.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSAllStepCell.h"

@interface VHSAllStepCell ()

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *steps;

@end

@implementation VHSAllStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setStepModel:(EveryDayStepModel *)stepModel {
    _stepModel = stepModel;
    
    self.time.text = _stepModel.ctime;
    self.steps.text = _stepModel.allstep;
}

@end
