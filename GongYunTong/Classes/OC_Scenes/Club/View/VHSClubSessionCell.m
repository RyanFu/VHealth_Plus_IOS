//
//  VHSClubSessionCell.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/13.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSClubSessionCell.h"

@interface VHSClubSessionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *reddot;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewConstraint;

@end

@implementation VHSClubSessionCell

- (void)setClub:(ClubModel *)club {
    if (_club != club) {
        _club = club;
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_club.coverUrl] placeholderImage:[UIImage imageNamed:@"discover_club_placehold"]];
        self.titleLabel.text = _club.clubName;
        self.reddot.hidden = !_club.newMsg;
        self.describeLabel.text = _club.slogan;
        self.peopleLabel.text = [NSString stringWithFormat:@"已有%@人", _club.memberCount];
        self.footerView.hidden = !_club.haveFooter;
        
        if (_club.haveFooter) {
            self.headImageViewConstraint.constant = -10;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.reddot.layer.cornerRadius = CGRectGetWidth(self.reddot.frame) / 2.0;
    self.reddot.layer.masksToBounds = YES;
    
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
