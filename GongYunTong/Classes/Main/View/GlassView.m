//
//  GlassView.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "GlassView.h"

@interface GlassView ()

@property(nonatomic,weak)UIVisualEffectView *visEffectView;
@end

@implementation GlassView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //毛玻璃效果
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * ve = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        ve.alpha=1.0;
        [self addSubview:ve];
        self.visEffectView=ve;
    }
    return self;
}
//设置visEffectView的大小位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.visEffectView.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)showToView:(UIView *)view
{
    [view addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}
@end
