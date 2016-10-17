//
//  VHSAboutSpaceCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSAboutSpaceCell.h"

@interface VHSAboutSpaceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end

@implementation VHSAboutSpaceCell

- (void)setDynamicItem:(DynamicItemModel *)dynamicItem {
    
    _dynamicItem = dynamicItem;
    
    if (_dynamicItem.urls) {
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:_dynamicItem.urls] placeholderImage:[UIImage imageNamed:@"pic_dynamic_default200_120"]];
    }
    self.contentLabel.text = _dynamicItem.title;
    self.timelabel.text = _dynamicItem.pubTime;
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
