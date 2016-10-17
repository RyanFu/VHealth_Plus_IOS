
//
//  VHSStartController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSStartController.h"
#import "UILabel+extension.h"

@interface VHSStartController ()

@property (weak, nonatomic) IBOutlet UIImageView *startImageView;

@end

@implementation VHSStartController

- (void)setDurationTime:(NSInteger)durationTime {
    if (durationTime < 0) {
        durationTime = 3;
    }
    _durationTime = durationTime;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.startImageView sd_setImageWithURL:[NSURL URLWithString:self.launchUrl] placeholderImage:[UIImage imageNamed:@"gongyuntong_default_launch"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
