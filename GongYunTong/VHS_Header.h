//
//  VHS_Header.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#ifndef VHS_Header_h
#define VHS_Header_h

//**打印**//
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define iphone4x_3_5     ([UIScreen mainScreen].bounds.size.height==480.0f)

// 系统版本7.0以后
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define NAVIAGTION_HEIGHT 64
#define TABBAR_HEIGHT 44
// RGB颜色创建
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLORHex(x) [UIColor colorWithHexString:x]

// 定义项目中常用的颜色
#define COLOR_TEXT_PLACEHOLDER  RGBCOLOR(204.0, 204.0, 204.0) // textView 和 textField占位符的字体颜色
#define COLOR_TEXT              RGBCOLOR(33.0 , 33.0, 33.0)   // 文本的输入颜色，及大部分label的颜色
#define COLOR_BG_TABLEVIEW      RGBCOLOR(239.0, 239.0, 244.0) // 背景色


#define k_UserDefaults            [NSUserDefaults standardUserDefaults]     // NSUsetDefault
#define k_NotificationCenter      [NSNotificationCenter defaultCenter]      // NSNotificationCenter


#endif /* VHS_Header_h */
