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

@property (weak, nonatomic) IBOutlet UIImageView    *hudIgv;
@property (weak, nonatomic) IBOutlet UILabel        *numberLabel;
@property (nonatomic, assign) NSInteger              number;
@property (nonatomic, strong) NSTimer                *timer;

@property (nonatomic, copy) void (^toastShowBlock)();

@end

@implementation VHSTimeToast

+ (void)toastShow:(NSInteger)time success:(void (^)())showSuccessBlock {
    VHSTimeToast *toast = [self timeToastFromXib];
    toast.frame = [UIScreen mainScreen].bounds;
    toast.number = time;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController.view addSubview:toast];
    [toast.hudIgv startRotateAnimation:0.8];
    
    if (showSuccessBlock) {
        toast.toastShowBlock = showSuccessBlock;
    }
}

+(void)toastShow:(NSInteger)time {
    [self toastShow:time success:nil];
}
+(instancetype)timeToastFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(numberLabelNumberChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.hidden = NO;
    [self.timer setFireDate:[NSDate distantPast]];
}

-(void)numberLabelNumberChange {
    self.numberLabel.text=[NSString stringWithFormat:@"%ld", (long)self.number];
    if (self.number <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.hudIgv stopAllAnimation];
        self.hidden = YES;
        
        if (self.toastShowBlock) {
            self.toastShowBlock();
        }
        
        [self removeFromSuperview];
    }
    self.number--;
}

@end
