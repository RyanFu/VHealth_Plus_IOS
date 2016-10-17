//
//  VHSDynamicBigIgvCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSDynamicBigIgvCell.h"

@interface VHSDynamicBigIgvCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageview;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation VHSDynamicBigIgvCell

- (void)setDynamicItem:(DynamicItemModel *)dynamicItem {
    _dynamicItem = dynamicItem;
    
    if (_dynamicItem.urls) {
        [self.bigImageview sd_setImageWithURL:[NSURL URLWithString:_dynamicItem.urls] placeholderImage:[UIImage imageNamed:@"pic_dynamic_default750_320"]];
    }
    self.title.text = _dynamicItem.title;
    self.time.text = _dynamicItem.pubTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
