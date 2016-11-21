//
//  SecurityUtil.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject

+ (SecurityUtil *)share;

/// 数组，字典转换成Json字符串
- (NSString *)toJsonString:(id)content;

/// 非对称加密加密AES的密码
- (NSString *)rasEncryptPsd;
/// 使用非对称加密加密字符串
- (NSString *)rsaEncryptStr:(NSString *)unEncryptStr;


/// 项目参数加密
- (NSDictionary *)encryptBody:(id)params;
/// 项目参数解密
- (NSDictionary *)decryptBody:(NSDictionary *)params;

@end
