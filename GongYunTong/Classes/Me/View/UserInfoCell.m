//
//  UserInfoCell.m
//  sym
//
//  Created by zhangshupeng on 16/7/25.
//  Copyright © 2016年 sym. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;

@end

@implementation UserInfoCell

#pragma mark - override setter method

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    
    if (_headerImageUrl.length == 0 || [_headerImageUrl isEqualToString:@""]) {
        self.head.hidden = YES;
    } else {
        self.head.image = [UIImage imageNamed:_headerImageUrl];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
