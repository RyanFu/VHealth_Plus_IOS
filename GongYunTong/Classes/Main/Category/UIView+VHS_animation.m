//
//  UIView+VHS_animation.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "UIView+VHS_animation.h"

@implementation UIView (VHS_animation)


-(void)startRotateAnimation{
    self.hidden=NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:rotationAnimation forKey:@"VHSrotationAnimation"];
}

-(void)startRotateAnimation:(double)duration
{
    self.hidden=NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAnimation forKey:@"VHSrotationAnimation"];
}
-(void)stopAllAnimation
{
    [self.layer removeAllAnimations];
    self.hidden=YES;
}
@end
