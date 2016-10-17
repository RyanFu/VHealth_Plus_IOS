//
//  UIBarButtonItem+VHS_extension.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (VHS_extension)

/** 根据图片生成高亮和正常状态的Item*/
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
/** 高亮、正常、不可选状态的纯文字Item*/ //这里可不需要传disabledcolor，当设置self.navigationItem.rightBarButtonItem.enabled=NO;时，系统自己会变成不可选中颜色
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title normalColor:(UIColor *)normalColor highColor:(UIColor *)highColor disabledColor:(UIColor *)disabledColr;
@end
