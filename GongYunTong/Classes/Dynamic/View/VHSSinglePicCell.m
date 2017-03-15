//
//  VHSAboutSpaceCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSSinglePicCell.h"

@interface VHSSinglePicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *outlineLabel;

@end

@implementation VHSSinglePicCell

- (void)setDynamicItem:(DynamicItemModel *)dynamicItem {
    
    _dynamicItem = dynamicItem;
    
    if (_dynamicItem.urls) {
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:_dynamicItem.urls] placeholderImage:[UIImage imageNamed:@"dynamic_list_single_placehold"]];
    }
    self.contentLabel.text = _dynamicItem.title;
    self.timelabel.text = _dynamicItem.pubTime;
    self.outlineLabel.text = _dynamicItem.dynamicZyText;
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
