//
//  UIView+extension.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/19.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "UIView+extension.h"

@implementation UIView (extension)

- (void)vhs_drawCornerRadius {
    CGFloat radius = self.frame.size.width / 2.0;
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
