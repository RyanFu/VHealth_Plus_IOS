//
//  VHSDynamicBannerCell.m
//  GongYunTong
//
//  Created by vhsben on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDynamicBannerCell.h"

@implementation VHSDynamicBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENW, self.contentView.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"pic_dynamic_default750_350"]];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.pageDotColor = RGBACOLOR(245, 245, 245, 0.5);
    self.bannerView.currentPageDotColor = COLORHex(@"#dc3c38");
    self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bannerView.hidesForSinglePage = YES;
    [self.contentView addSubview:self.bannerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
