//
//  VHSMeScoreCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/9/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSMeScoreCell.h"

@interface VHSMeScoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *rateGold;
@property (weak, nonatomic) IBOutlet UILabel *scoreNumber;
@property (weak, nonatomic) IBOutlet UILabel *rateGoldNumber;

@end

@implementation VHSMeScoreCell

- (void)setHeaderUrl:(NSString *)headerUrl {
    _headerUrl = headerUrl;
    
    self.headImageView.image = [UIImage imageNamed:_headerUrl];
}

- (void)setScoreContent:(NSString *)scoreContent {
    _scoreContent = scoreContent;
    
    self.score.text = _scoreContent;
}

- (void)setScoreNumberContent:(NSString *)scoreNumberContent {
    _scoreNumberContent = scoreNumberContent;
    
    self.scoreNumber.text = _scoreNumberContent;
}

- (void)setRateGoldContent:(NSString *)rateGoldContent {
    _rateGoldContent = rateGoldContent;
    
    self.rateGold.text = _rateGoldContent;
}

- (void)setRateGoldNumberContent:(NSString *)rateGoldNumberContent {
    _rateGoldNumberContent = rateGoldNumberContent;
    
    self.rateGoldNumber.text = _rateGoldNumberContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


@end
