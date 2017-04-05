//
//  VHSSettingBraceletCell.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/28.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSSettingBraceletCell.h"
#import "VHSFitBraceletSettingModel.h"
#import "UIView+animation.h"
#import "NSDate+VHSExtension.h"

@interface VHSSettingBraceletCell ()

@property (weak, nonatomic) IBOutlet UIImageView *settingImage;
@property (weak, nonatomic) IBOutlet UILabel *settingOperation;
@property (weak, nonatomic) IBOutlet UILabel *settingOperationDetail;
@property (weak, nonatomic) IBOutlet UIImageView *waitingIgv;

@end

@implementation VHSSettingBraceletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=RGBCOLOR(204, 204, 204);
    [self addSubview:line];
    @WeakObj(self);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(selfWeak.mas_left).with.offset(0);
        make.right.equalTo(selfWeak.mas_right).with.offset(0);
        make.bottom.equalTo(selfWeak.mas_bottom).with.offset(0);
    }];
}
-(void)setModel:(VHSFitBraceletSettingModel *)model
{
    _model = model;
    self.settingImage.image = [UIImage imageNamed:model.settingImage];
    self.settingOperation.text = model.settingOperation;
    self.settingOperationDetail.text = [NSDate mmddhhmmWithDateStr:model.settingOperationDetail];
}
-(void)setIsDisBinding:(BOOL)isDisBinding {
    _isDisBinding = isDisBinding;
    if (isDisBinding) {
        [self.waitingIgv startRotateAnimation];
        self.settingOperationDetail.hidden = YES;
    }else{
        [self.waitingIgv stopAllAnimation];
        self.settingOperationDetail.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
