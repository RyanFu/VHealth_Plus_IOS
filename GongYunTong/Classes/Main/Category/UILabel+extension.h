//
//  UILabel+extension.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/30.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)

/**
 *  倒计时label
 *
 *  @param durationTime 持续时间
 */
- (void)countDownWithSeconds:(NSInteger)durationTime;

@end
