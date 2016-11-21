//
//  SecurityUtil.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "SecurityUtil.h"
#import "NSData+AES256.h"
#import "NSString+AES256.h"
#import "RSAEncryptor.h"
#import "NSArray+VHSExtension.h"
#import "NSDictionary+VHSExtension.h"
#import "NSString+VHSExtension.h"

/**
 *  项目采用的加密方式是对称加密AES和非对称加密RAS加密结合的方式
 *
 *  非对称RSA加密需要：1. 用于加密的公钥Public_key.cer
 *  对称AES加密需要：1. 需要加密的参数   2. 加密用的password
 *
 *  具体的实现思路
 *
 *  Client iOS端
 *
 *  (上传部分)
 *  1. 用RSA对password加密得到密文m1
 *  2. 参数params->(to json)->Json字符串->(AES+password)->密文m2
 *  3. 将密文m1和密文m2打包成字典上传到服务器
 *  (获取部分)
 *  4. 获取到服务器数据通过key->(RSA解密)->获取到password
 *  5. 获取到服务器数据通过value->(AES+password)->明文的后台返回值
 *
 *
 *  Server Java
 *  1. 用privity_key.p12对密文m1->(RSA)->明文password
 *  2. 对获取的加密后params->(AES+password)->密文m2->解密得到Json字符串
 *  3. 将Json字符串转为正常使用的params
 *
 **/

#define PUBLIC_KEY_PASSWORD @"0123456789abcdef"

@interface SecurityUtil ()

@property (nonatomic, strong) NSString *aesPassword;

@end

@implementation SecurityUtil

+ (SecurityUtil *)share {
    static SecurityUtil *securer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        securer = [[SecurityUtil alloc] init];
    });
    return securer;
}

/// 数组，字典转换成Json字符串
- (NSString *)toJsonString:(id)content {
    NSString *jsonStr = @"";
    if ([content isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)content;
        jsonStr = [arr convertJson];
    }
    else if ([content isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)content;
        jsonStr = [dic convertJson];
    }
    else if ([content isKindOfClass:[NSString class]] || [content isKindOfClass:[NSNumber class]]) {
        jsonStr = [content stringValue];
    }
    return jsonStr;
}

/// 非对称加密加密AES的密码
- (NSString *)rasEncryptPsd {
    return [self rsaEncryptStr:PUBLIC_KEY_PASSWORD];
}

/// 使用非对称加密RSA加密字符串
- (NSString *)rsaEncryptStr:(NSString *)unEncryptStr {
    RSAEncryptor *encryptor = [RSAEncryptor sharedInstance];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    [encryptor loadPublicKeyFromFile:path];
    NSString *rsaEncrypedStr = @"";
    if (![VHSCommon isNullString:unEncryptStr]) {
        rsaEncrypedStr = [encryptor rsaEncryptString:unEncryptStr];
    }
    return rsaEncrypedStr;
}

/// 非对称RSA解密
- (NSString *)rsaDecryptStr:(NSString *)encrpytedStr {
    RSAEncryptor *encryptor = [RSAEncryptor sharedInstance];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"server_private_key" ofType:@"der"];
    [encryptor loadPrivateKeyFromFile:path password:@"11111"];
    return [encryptor rsaDecryptString:encrpytedStr];
}

/// AES加密
- (NSString *)aesEncryptStr:(NSString *)str {
    return [str aes256_encrypt:PUBLIC_KEY_PASSWORD];
}

/// AES解密
- (NSString *)aesDecryptStr:(NSString *)str pwd:(NSString *)pwd {
    return [str aes256_decrypt:pwd];
}

/// 项目参数加密
- (NSDictionary *)encryptBody:(id)params {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    /// 对称加密加密jsonStr
    NSString *jsonBody = [self toJsonString:params];
    NSString *jsonEncryptStr = [self aesEncryptStr:jsonBody];
    
    /// 非对称加密加密密码
    NSString *jsonPsd = [self rsaEncryptStr:PUBLIC_KEY_PASSWORD];
    
    [dic setObject:jsonPsd forKey:@"key"];
    [dic setObject:jsonEncryptStr forKey:@"value"];
    
    return dic;
}

/// 项目参数解密
- (NSDictionary *)decryptBody:(NSDictionary *)params {
    
    NSString *key = params[@"key"];
    NSString *value = params[@"value"];
    
    /// RSA对key进行解密
    NSString *password = [self rsaDecryptStr:key];
    /// AES+password对value解密
    NSString *jsonStr = [self aesDecryptStr:value pwd:password];
    
    /// json字符串转为字典或者数组
    NSDictionary *dic = [jsonStr convertObject];
    
    return dic;
}

@end
