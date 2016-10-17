//
//  UIBarButtonItem+VHS_extension.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "UIBarButtonItem+VHS_extension.h"

@implementation UIBarButtonItem (VHS_extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    if (image&&image.length!=0) {
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (highImage&&highImage.length!=0) {
        [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    // 设置尺寸
    btn.bounds =CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title normalColor:(UIColor *)normalColor highColor:(UIColor *)highColor disabledColor:(UIColor *)disabledColr
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    if (normalColor) {
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (highColor) {
        [btn setTitleColor:highColor forState:UIControlStateHighlighted];
    }
    if (disabledColr) {
        [btn setTitleColor:disabledColr forState:UIControlStateDisabled];
    }
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    btn.bounds=CGRectMake(0, 0, 40, 40);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end
