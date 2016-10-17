//
//  VHSUnBindCell.m
//  VHealth1.6
//
//  Created by vhsben on 16/7/6.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSUnBindCell.h"

@implementation VHSUnBindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
- (IBAction)unBindClick:(id)sender {
    if (self.clickDelegate &&[self.clickDelegate respondsToSelector:@selector(vHSUnBindCellClick:)]) {
        [self.clickDelegate vHSUnBindCellClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
