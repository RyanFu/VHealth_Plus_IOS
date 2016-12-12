//
//  VHSMoreIgvCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSMoreIgvCell.h"

@interface VHSMoreIgvCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *outlineLabel;


@end

@implementation VHSMoreIgvCell

- (void)setDynamicItem:(DynamicItemModel *)dynamicItem {
    
    _dynamicItem = dynamicItem;
    
    // 三图样式的cell中的url用","分割
    NSArray *urls = [_dynamicItem.urls componentsSeparatedByString:@","];
    for (NSInteger i = 0; i < [urls count]; i++) {
        NSURL *url = url = [NSURL URLWithString:urls[i]];
        if (i == 0) {
            [self.firstImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pic_dynamic_default200_120"]];
        }
        else if (i == 1) {
            [self.secondImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pic_dynamic_default200_120"]];
        }
        else if (i == 2) {
            [self.thirdImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pic_dynamic_default200_120"]];
        }
    }
    self.title.text = _dynamicItem.title;
    self.time.text = _dynamicItem.pubTime;
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
