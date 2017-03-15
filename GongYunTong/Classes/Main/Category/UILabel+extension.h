//
//  UILabel+extension.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/30.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)

/**
 *  倒计时label
 *
 *  @param durationTime 持续时间
 */
- (void)countDownWithSeconds:(NSInteger)durationTime;

/// label 宽高自适应，需开始先设置好label对应的frame
- (CGSize)sizeFit;
/// 确定行间距
- (void)lineSpacingWithSpace:(CGFloat)space;

@end
