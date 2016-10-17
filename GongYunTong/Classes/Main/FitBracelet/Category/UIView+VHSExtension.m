//
//  UIView+VHSExtension.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/29.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "UIView+VHSExtension.h"

@implementation UIView (VHSExtension)


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
