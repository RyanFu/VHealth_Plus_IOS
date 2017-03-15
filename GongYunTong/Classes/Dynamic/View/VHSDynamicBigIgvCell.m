//
//  VHSDynamicBigIgvCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDynamicBigIgvCell.h"

@interface VHSDynamicBigIgvCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bigImageview;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *outlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation VHSDynamicBigIgvCell

- (void)setDynamicItem:(DynamicItemModel *)dynamicItem {
    _dynamicItem = dynamicItem;
    
    if (_dynamicItem.urls) {
        [self.bigImageview sd_setImageWithURL:[NSURL URLWithString:_dynamicItem.urls] placeholderImage:[UIImage imageNamed:@"dynamic_list_big_placehold"]];
    }
    self.title.text = _dynamicItem.title;
    self.time.text = _dynamicItem.pubTime;
    self.outlineLabel.text = _dynamicItem.dynamicZyText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
