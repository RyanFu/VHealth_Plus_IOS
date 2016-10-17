//
//  VHSTimeToast.m
//  VHealth1.6
//
//  Created by vhsben on 16/7/8.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSTimeToast.h"
#import "MBProgressHUD.h"
#import "UIView+VHSExtension.h"

@interface VHSTimeToast ()



@property (weak, nonatomic) IBOutlet UIImageView *hudIgv;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic)NSInteger number;
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation VHSTimeToast


+(void)toastShow:(NSInteger)time
{
    VHSTimeToast *toast=[self timeToastFromXib];
    toast.frame = [UIScreen mainScreen].bounds;
    toast.number=time;
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    [window.rootViewController.view addSubview:toast];
    [toast.hudIgv startRotateAnimation:0.8];
}
+(instancetype)timeToastFromXib{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(numberLabelNumberChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.hidden=NO;
//    self.number=5;
//    CAShapeLayer *layer=[CAShapeLayer layer];
//    layer.lineWidth=1.0;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
//    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 60, 60)];
//    layer.path=path.CGPath;
//    [self.contents.layer addSublayer:layer];
    [self.timer setFireDate:[NSDate distantPast]];
}

-(void)numberLabelNumberChange
{
    self.numberLabel.text=[NSString stringWithFormat:@"%ld",self.number];
    if (self.number<=0) {
        [self.timer invalidate];
        self.timer=nil;
        [self.hudIgv stopAllAnimation];
        self.hidden=YES;
        [self removeFromSuperview];
    }
    self.number--;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
