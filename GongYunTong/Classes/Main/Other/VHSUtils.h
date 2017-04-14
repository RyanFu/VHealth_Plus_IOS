//
//  VHSUntils.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "KeyChainStore.h"

@interface VHSUtils : NSObject

/// md5加密使用C字符加密
+ (NSString *)md5_c:(NSString *)str;
/// md5加密使用16进制编码
+ (NSString *)md5_hex:(NSString *)str;
/// md5加密使用base64编码
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

/// 获取本地的图片地址
+ (NSString *)getLocalImageWithPath:(NSString *)urlPath;

/// 生成一个16位数的随机数字符串
+ (NSString *)generateRandomStr16;
/// 判断一个字符串是否是url，判断能否访问成功
+ (void)smartJumpWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSString *url))urlCompletionHandler;
/// 获取项目中最顶层的Controller
+ (UIViewController *)getTopLevelController;

@end
