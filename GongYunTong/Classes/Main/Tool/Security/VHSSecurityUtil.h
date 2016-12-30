//
//  SecurityUtil.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSSecurityUtil : NSObject

+ (VHSSecurityUtil *)share;

/// 数组，字典转换成Json字符串
- (NSString *)toJsonString:(id)content;

/// 用rsa利用一个16位随机数生成的密文
- (NSString *)rsaGenerateKeyOfRandomStr16WithKey:(NSString *)key;
/// 使用非对称加密加密字符串
- (NSString *)rsaEncryptStr:(NSString *)unEncryptStr;

/// AES 加密
- (NSString *)aesEncryptStr:(NSString *)str pwd:(NSString *)pwd;
/// AES 解密
- (NSString *)aesDecryptStr:(NSString *)str pwd:(NSString *)pwd;

/// 获取加密数据的签名
- (NSString *)signWithKeyStr:(NSString *)keystr;

/// randomPwd : 16位的随机数，data : 需要出给服务器的真正数据，sign : 网络传输签名，防止数据在网络传输中被篡改
- (NSDictionary *)encryptWithRandomKey:(NSString *)randomPwd data:(NSDictionary *)originParams sign:(NSString *)sign;

@end
