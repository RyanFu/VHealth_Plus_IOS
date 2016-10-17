//
//  UIView+VHSExtension.h
//  VHealth1.6
//
//  Created by vhsben on 16/6/29.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VHSExtension)

// 旋转动画（菊花转动）
-(void)startRotateAnimation;



// 旋转动画 duration越小 转的越快
-(void)startRotateAnimation:(double)duration;
// 停止动画
-(void)stopAllAnimation;


@end
