//
//  VHSNormalCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSNormalCell.h"

@interface VHSNormalCell ()

@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation VHSNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShouldHiddenLine:(BOOL)shouldHiddenLine {
    _shouldHiddenLine = shouldHiddenLine;
    
    self.line.hidden = _shouldHiddenLine;
}


@end
