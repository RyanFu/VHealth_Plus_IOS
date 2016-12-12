//
//  VHSPaymentsDetailCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSPaymentsDetailCell.h"

@interface VHSPaymentsDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *overplusGold;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation VHSPaymentsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShouldHiddenLine:(BOOL)shouldHiddenLine {
    _shouldHiddenLine = shouldHiddenLine;
    
    self.line.hidden = _shouldHiddenLine;
}

- (void)setBalanceItem:(BalanceItemModel *)balanceItem {
    _balanceItem = balanceItem;
    
    _title.text = _balanceItem.actionName;
    _time.text = _balanceItem.ctime;
    _detail.text = [NSString stringWithFormat:@"%@", _balanceItem.score ? _balanceItem.score : @""];
    _overplusGold.text = [NSString stringWithFormat:@"%@", _balanceItem.gold];
}

@end
