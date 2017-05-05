//
//  VHSActionCell.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/5/3.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSActionCell.h"

@interface VHSActionCell ()

@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@end

@implementation VHSActionCell

- (void)setAction:(VHSActionData *)action {
    _action = action;
    
    _recordTimeLabel.text = _action.recordTime;
    _stepLabel.text = _action.step;
    _macLabel.text = _action.macAddress;
    _initialStepLabel.text = _action.initialStep;
    _deviceStepLabel.text = _action.currentDeviceStep;
    _uploadLabel.text = @(_action.upload).stringValue;
    _memberIdLabel.text = action.memberId;
    _createTimeLabel.text = action.startTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
