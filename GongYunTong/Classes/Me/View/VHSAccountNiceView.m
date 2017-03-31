//
//  VHSAccountNiceView.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/28.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSAccountNiceView.h"
#import "NSString+extension.h"

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

- (void)alertWithTitle:(NSString *)title prompt:(NSString *)prompt actions:(NSArray *)actions {
    if ([actions count] > 2) return;
    
    self.bgBoardView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgBoardView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:[VHSAccountNiceView share].bgBoardView];
    
    CGFloat containW = SCREENW * 0.8;
    CGFloat containH = containW * 0.6;
    
    UIView *bgContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containW, containH)];
    bgContainView.center = [VHSAccountNiceView share].bgBoardView.center;
    bgContainView.backgroundColor = [UIColor whiteColor];
    [[VHSAccountNiceView share].bgBoardView addSubview:bgContainView];
    
    bgContainView.layer.cornerRadius = 6.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containW, containH * 0.25)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = COLORHex(@"#e65248");
    [bgContainView addSubview:titleLabel];
    
    // 创建蒙版
    CGRect maskRect = CGRectMake(0, 0, titleLabel.bounds.size.width, titleLabel.bounds.size.height);
    CGSize maskRadius = CGSizeMake(4, 4);
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:maskRect byRoundingCorners:corners cornerRadii:maskRadius];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    titleLabel.layer.mask = shapeLayer;
    
    
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame), containW - 10, containH * 0.5)];
    contentlabel.text = prompt;
    contentlabel.textColor = [UIColor grayColor];
    contentlabel.textAlignment = NSTextAlignmentCenter;
    contentlabel.numberOfLines = 0;
    contentlabel.font = [UIFont systemFontOfSize:15];
    [bgContainView addSubview:contentlabel];
    // 动态计算label宽高
    CGSize contentSize = [contentlabel.text computerWithSize:CGSizeMake(contentlabel.frame.size.width, CGFLOAT_MAX) font:contentlabel.font];
    
    if (contentSize.height > containH * 0.5) {
        contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, contentSize.width, contentSize.height);
        
        CGRect frame = bgContainView.frame;
        frame.size.height = frame.size.height + contentSize.height - containH * 0.5;
        
        bgContainView.frame = frame;
    }
    
    CGFloat btnW = containW  * 0.35;
    CGFloat space = 29.0;
    CGFloat bgContainW = CGRectGetWidth(bgContainView.frame);
    CGFloat marginX = (bgContainW - (btnW * [actions count] + space * (actions.count - 1))) / 2.0;
    
    for (NSInteger i = 0; i < [actions count]; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(marginX + (btnW + space) * i,
                                                                   CGRectGetMaxY(contentlabel.frame),
                                                                   btnW,
                                                                   0.2 * containH)];
        [btn setTitle:actions[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:COLORHex(@"#e65248")];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([actions count] == 2) {
            if (i % 2 == 0) {
                [btn setBackgroundColor:COLORHex(@"#e65248")];
                btn.tag = 10000;
            } else {
                [btn setBackgroundColor:COLORHex(@"#999999")];
                btn.tag = 10001;
            }
        } else {
            btn.tag = 20000;
        }
        
        [bgContainView addSubview:btn];
        
        btn.layer.cornerRadius = 3.0;
        btn.layer.masksToBounds = YES;
    }
}

- (void)btnAction:(UIButton *)btn {
    [self.bgBoardView removeFromSuperview];
    // 网络请求
    if (btn.tag == 10000) {
        [self openAccount];
    }
}

- (void)openAccount {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_DO_INVATION_MEMBER;
    message.httpMethod = VHSNetworkPOST;
    message.params = self.invitationInfoDict;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        [VHSToast toast:result[@"info"]];
        if ([result[@"result"] integerValue] != 200) {
            return;
        }
        
        [[VHSAccountNiceView share] alertWithTitle:@"账号开通成功" prompt:@"已经成功将登陆信息发送至被邀请者手机号" actions:@[@"确定"]];
    } fail:^(NSError *error) {
        CLog(@"--->>> 邀请开通账号失败 -->>%@", error.description);
    }];
}

@end
