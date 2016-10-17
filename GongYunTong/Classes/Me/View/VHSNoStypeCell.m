//
//  VHSNoStypeCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/9/14.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSNoStypeCell.h"

@interface VHSNoStypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;


@end

@implementation VHSNoStypeCell


#pragma mark - override setter method

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    
    if (_headerImageUrl.length == 0 || [_headerImageUrl isEqualToString:@""]) {
        self.headerImage.hidden = YES;
    } else {
        self.headerImage.image = [UIImage imageNamed:_headerImageUrl];
    }
}

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitle = cellTitle;
    
    self.title.text = _cellTitle;
}

- (void)setCellInfo:(NSString *)cellInfo {
    _cellInfo = cellInfo;
    
    self.info.text = _cellInfo;
}

@end
