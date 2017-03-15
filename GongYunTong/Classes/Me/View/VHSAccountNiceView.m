//
//  VHSAccountNiceView.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/28.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSAccountNiceView.h"

@interface VHSAccountNiceView ()

@property (nonatomic, strong) UIView *bgBoardView;

@end

@implementation VHSAccountNiceView

+ (VHSAccountNiceView *)share {
    static VHSAccountNiceView *niceView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        niceView = [[VHSAccountNiceView alloc] init];
    });
    return niceView;
}

+ (void)showWithMainContent:(NSString *)mainContent {
    [VHSAccountNiceView share].bgBoardView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [VHSAccountNiceView share].bgBoardView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:[VHSAccountNiceView share].bgBoardView];
    
    CGFloat containW = SCREENW * 0.8;
    CGFloat containH = containW * 0.6;
    
    UIView *bgContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containW, containH)];
    bgContainView.center = [VHSAccountNiceView share].bgBoardView.center;
    bgContainView.backgroundColor = [UIColor whiteColor];
    [[VHSAccountNiceView share].bgBoardView addSubview:bgContainView];
    
    bgContainView.layer.cornerRadius = 3.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containW, containH * 0.25)];
    titleLabel.text = CONST_OPEN_ACCOUNT_SUCCESS;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = COLORHex(@"#e65248");
    [bgContainView addSubview:titleLabel];
    
    // 创建蒙版
    CGRect maskRect = CGRectMake(0, 0, titleLabel.bounds.size.width, titleLabel.bounds.size.height);
    CGSize maskRadius = CGSizeMake(3, 3);
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:maskRect byRoundingCorners:corners cornerRadii:maskRadius];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    titleLabel.layer.mask = shapeLayer;
    
    
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame), containW - 10, containH * 0.5)];
    contentlabel.text = mainContent;
    contentlabel.textColor = [UIColor grayColor];
    contentlabel.textAlignment = NSTextAlignmentCenter;
    contentlabel.numberOfLines = 0;
    [bgContainView addSubview:contentlabel];

    
    CGFloat confirmBtnW = containW  * 0.35;
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(bgContainView.frame) - confirmBtnW) / 2, CGRectGetMaxY(contentlabel.frame), confirmBtnW, 0.2 * containH)];
    [confirmBtn setTitle:CONST_CONFIRM forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLORHex(@"#e65248")];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgContainView addSubview:confirmBtn];
    
    confirmBtn.layer.cornerRadius = 3.0;
    confirmBtn.layer.masksToBounds = YES;
}

+ (void)confirmBtnClick:(UIButton *)btn {
    [[VHSAccountNiceView share].bgBoardView removeFromSuperview];
}

@end
