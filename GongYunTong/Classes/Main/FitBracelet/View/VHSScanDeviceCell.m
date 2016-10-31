//
//  VHSScanDeviceCell.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/27.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSScanDeviceCell.h"

@interface VHSScanDeviceCell ()


@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@end

@implementation VHSScanDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setModel:(PeripheralModel *)model
{
    _model=model;
    //重置cell
    self.userInteractionEnabled=YES;
    [self.bingButton setTitle:@"点击绑定" forState:UIControlStateNormal];
    self.bingButton.hidden=NO;
    self.waitingIgv.hidden=YES;
    [self.waitingIgv.layer removeAllAnimations];
    self.modelLabel.text = [NSString stringWithFormat:@"%@ %ld",model.name,(long)model.RSSI];
    
}
- (IBAction)bingClick:(UIButton *)sender {
    sender.hidden=YES;
    self.waitingIgv.hidden=NO;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(vhsScanDeviceCellBindClick:)]) {
        [self.delegate vhsScanDeviceCellBindClick:self];
    }
}
// 重复旋转动画
- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.waitingIgv.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
