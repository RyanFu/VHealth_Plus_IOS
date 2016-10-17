//
//  VHSSettingCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSSettingCell.h"

@interface VHSSettingCell ()

@property (weak, nonatomic) IBOutlet UILabel *switchLabel;

@end

@implementation VHSSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self judgeNotificationSwitch];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)judgeNotificationSwitch {
    if (iOS8) { //iOS8以上包含iOS8 - 没有打开通知
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
            [self setSwitch:NO];
        } else {
            [self setSwitch:YES];
        }
    }
}

- (void)setSwitch:(BOOL)isOpen {
    
    if (isOpen) {
        self.switchLabel.text = @"已开启";
        self.switchLabel.textColor = RGBCOLOR(130.0, 130.0, 130.0);
    } else {
        self.switchLabel.text = @"已关闭";
        self.switchLabel.textColor = RGBCOLOR(130.0, 130.0, 130.0);
    }
}

@end
