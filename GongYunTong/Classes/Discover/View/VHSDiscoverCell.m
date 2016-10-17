//
//  VHSDiscoverCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/22.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSDiscoverCell.h"

@interface VHSDiscoverCell ()


@property (weak, nonatomic) IBOutlet UILabel *disvoverNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *discoverIgv;
@property (nonatomic,strong)CALayer *rightLine;
@property (nonatomic,strong)CALayer *bottomLine;
@end

@implementation VHSDiscoverCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    for (int i = 0; i < 2; i++) {
        CALayer *line = [CALayer layer];
        line.backgroundColor = COLORHex(@"#EFEFF4").CGColor;
        [self.contentView.layer addSublayer:line];
        if (i == 0) {
            self.rightLine = line;
        } else {
            self.bottomLine = line;
        }
    }
   
    UIView *selectedView=[[UIView alloc] init];
    selectedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    self.selectedBackgroundView = selectedView;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.rightLine.frame = CGRectMake(self.bounds.size.width - 1, 0, 1, self.bounds.size.height);
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
}

- (void)setBannerItem:(BannerItemModel *)bannerItem {
    
    _bannerItem = bannerItem;
    
    if (_bannerItem.title) {
        self.disvoverNameLabel.text = _bannerItem.title;
    } else {
        self.disvoverNameLabel.hidden = YES;
    }
    if (_bannerItem.hrefUrl) {
        [self.discoverIgv sd_setImageWithURL:[NSURL URLWithString:_bannerItem.iconUrl] placeholderImage:[UIImage imageNamed:@"300_icon_julebu"] options:SDWebImageRetryFailed];
    } else {
        self.discoverIgv.hidden = YES;
    }
    
    if (!_bannerItem.title) {
        self.userInteractionEnabled = NO;
    }
}

@end
