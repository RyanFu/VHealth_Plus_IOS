//
//  UIView+VHS_animation.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VHS_animation)

// 旋转动画（菊花转动）
-(void)startRotateAnimation;

// 旋转动画 duration越小 转的越快
-(void)startRotateAnimation:(double)duration;
// 停止动画
-(void)stopAllAnimation;
@end
