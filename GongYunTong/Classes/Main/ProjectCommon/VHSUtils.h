//
//  VHSUntils.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyChainStore.h"

@interface VHSUtils : NSObject

+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5_hex:(NSString *)str;
+ (NSString *)md5_base64:(NSString *)str;

/// 校验电话号码 - 简单
+ (BOOL)validateSimplePhone:(NSString *)phone;

/// 校验邮箱
+ (BOOL)validateEmail:(NSString *)email;

/// 正则判断手机号码格式 - 详细
+ (BOOL)validatePhone:(NSString *)phone;

/// 格式化电话
+ (NSString *)formatterMobile:(NSString *)mobile;

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
/**
 *  异步下载图片，存储到沙盒路径汇总
 */
+ (void)saveImageWithPath:(NSString *)urlPath;
// 随机生成16位的字符串
+ (NSString *)generateRandomStr16;
/// 判断一个字符串是否是url，判断能否访问成功
+ (void)smartJumpWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSString *url))urlCompletionHandler;
/// 获取本地的图片地址
+ (NSString *)getLocalImageWithPath:(NSString *)urlPath;
/// 获取项目中最顶层的Controller
+ (UIViewController *)getTopLevelController;

@end
