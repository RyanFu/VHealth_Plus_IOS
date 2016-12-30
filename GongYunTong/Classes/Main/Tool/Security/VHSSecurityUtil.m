//
//  SecurityUtil.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSSecurityUtil.h"
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

@interface VHSSecurityUtil ()

@property (nonatomic, strong) NSString *aesPassword;

@end

@implementation VHSSecurityUtil

+ (VHSSecurityUtil *)share {
    static VHSSecurityUtil *securer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        securer = [[VHSSecurityUtil alloc] init];
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

- (NSString *)rsaGenerateKeyOfRandomStr16WithKey:(NSString *)key {
    return [self rsaEncryptStr:key];
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
- (NSString *)aesEncryptStr:(NSString *)str pwd:(NSString *)pwd {
    return [str aes256_encrypt:pwd];
}

/// AES解密
- (NSString *)aesDecryptStr:(NSString *)str pwd:(NSString *)pwd {
    return [str aes256_decrypt:pwd];
}

- (NSString *)signWithKeyStr:(NSString *)keystr {
    return [VHSUtils md5_base64:keystr];
}

/// randomPwd : 16位的随机数，data : 需要出给服务器的真正数据，sign : 网络传输签名，防止数据在网络传输中被篡改
- (NSDictionary *)encryptWithRandomKey:(NSString *)randomPwd data:(NSDictionary *)originParams sign:(NSString *)sign {
    
    VHSSecurityUtil *security = [VHSSecurityUtil share];
    
    NSString *randomKey = [security rsaGenerateKeyOfRandomStr16WithKey:randomPwd];
    NSString *encryptdParams = nil;
    
    if ([VHSCommon isNullString:sign]) {
        NSString *jsonParams = [security toJsonString:originParams];
        encryptdParams = [security aesEncryptStr:jsonParams pwd:randomPwd];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:originParams];
        [params setObject:sign forKey:@"sign"];
        
        NSString *jsonParams = [security toJsonString:params];
        encryptdParams = [security aesEncryptStr:jsonParams pwd:randomPwd];
    }
    
    NSDictionary *destDict = @{@"key" : randomKey, @"data" : encryptdParams};
    
    return destDict;
}

@end
