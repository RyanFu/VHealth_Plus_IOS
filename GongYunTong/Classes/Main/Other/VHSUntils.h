//
//  VHSUntils.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyChainStore.h"

@interface VHSUntils : NSObject

/// 校验电话号码 - 简单
+ (BOOL)validateSimplePhone:(NSString *)phone;

/// 校验邮箱
+ (BOOL)validateEmail:(NSString *)email;

/// 正则判断手机号码格式 - 详细
+ (BOOL)validatePhone:(NSString *)phone;

/// 返回去除前后空格和换行符的字符串
+ (NSString *)absolutelyString:(NSString *)originString;

/// 获取纯颜色的图片
+ (UIImage *)imageFromColor:(UIColor *)color;

/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
+ (UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size;

@end
