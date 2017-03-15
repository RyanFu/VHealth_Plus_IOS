//
//  VHS_Header.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#ifndef VHS_Header_h
#define VHS_Header_h

// detail log
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d]\n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

// simple log
#ifdef DEBUG
# define CLog(...) NSLog(__VA_ARGS__);
#else 
# define CLog(...);
#endif

#define iphone4x_3_5     ([UIScreen mainScreen].bounds.size.height==480.0f)

// 系统版本7.0以后
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define NAVIAGTION_HEIGHT 64
#define TABBAR_HEIGHT 49
// RGB颜色创建
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLORHex(x) [UIColor colorWithHexString:x]

// 定义项目中常用的颜色
#define COLOR_TEXT_PLACEHOLDER  RGBCOLOR(204.0, 204.0, 204.0) // textView 和 textField占位符的字体颜色
#define COLOR_TEXT              RGBCOLOR(33.0 , 33.0, 33.0)   // 文本的输入颜色，及大部分label的颜色
#define COLOR_BG_TABLEVIEW      RGBCOLOR(239.0, 239.0, 244.0) // 背景色
#define COLOR_PROGRESS_BAR      RGBCOLOR(68.0, 187.0, 92.0)   // web的进度条颜色


#define k_UserDefaults            [NSUserDefaults standardUserDefaults]     // NSUsetDefault
#define k_NotificationCenter      [NSNotificationCenter defaultCenter]      // NSNotificationCenter


#endif
