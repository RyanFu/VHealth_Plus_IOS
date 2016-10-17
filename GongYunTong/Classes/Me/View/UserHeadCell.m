//
//  UserHeadCell.m
//  sym
//
//  Created by zhangshupeng on 16/7/25.
//  Copyright © 2016年 sym. All rights reserved.
//

#import "UserHeadCell.h"
#import "UIImageView+WebCache.h"

@interface UserHeadCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@end

@implementation UserHeadCell

#pragma mark - override setter method

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:_headerImageUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
}

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitle = cellTitle;
    
    self.title.text = _cellTitle;
}

- (void)setCellInfo:(NSString *)cellInfo {
    _cellInfo = cellInfo;
    
    self.info.text = _cellInfo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // iOS10 使用IB布局，需要先调用layoutIfNeeded，不然可能无法进行圆角设置
    [self.headerImage layoutIfNeeded];
    self.headerImage.layer.cornerRadius = (CGFloat)CGRectGetWidth(self.headerImage.frame) / 2.0;
    self.headerImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
