//
//  VHSReddotButton.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/13.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSReddotButton.h"

@interface VHSReddotButton ()

@property (nonatomic, strong) UIView *reddotView;

@end

@implementation VHSReddotButton

- (void)setIsShowReddot:(BOOL)isShowReddot {
    if (_isShowReddot != isShowReddot) {
        _isShowReddot = isShowReddot;
    }
    self.reddotView.hidden = !_isShowReddot;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        
        self.reddotView = [[UIView alloc] initWithFrame:CGRectMake(width, -1, 8, 8)];
        self.reddotView.backgroundColor = [UIColor redColor];
        [self addSubview:self.reddotView];
        
        self.reddotView.layer.cornerRadius = CGRectGetWidth(self.reddotView.frame) / 2.0;
    }
    return self;
}

@end
