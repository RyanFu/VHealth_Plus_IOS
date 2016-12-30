//
//  VHSHttpEngine.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSHttpEngine.h"
#import "AFNetworking.h"
#import "VHSSecurityUtil.h"
#import "NSString+VHSExtension.h"

@interface VHSHttpEngine ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

//连接超时秒
double const CONNECT_TIMEOUT = 10;
static VHSHttpEngine *_instance = nil;
@implementation VHSHttpEngine


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VHSHttpEngine alloc] init];
    });
    return _instance;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        [_manager.requestSerializer setValue:[VHSCommon vhstoken] forHTTPHeaderField:@"vhstoken"];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = CONNECT_TIMEOUT;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        // 安全验证 - reference : http://www.jianshu.com/p/f732749ce786
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode: AFSSLPinningModeCertificate];
        NSString *certificatePath = [[NSBundle mainBundle] pathForResource:@"vplus_https" ofType:@"cer"];
        NSData *certificateData = [NSData dataWithContentsOfFile:certificatePath];
        
        NSSet *certificateSet  = [[NSSet alloc] initWithObjects:certificateData, nil];
        [securityPolicy setPinnedCertificates:certificateSet];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy = securityPolicy;
    }
    return self;
}

- (void)getRequestWithResquestMessage:(VHSRequestMessage *)message success:(RequestSuccess)success failure:(RequestFailure)failure {
    
    if (![VHSCommon isNetworkAvailable]) {
        if (success) {
            success(nil);
        }
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:message.params];
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, message.path];
    DLog(@"URL %@", urlString);
    
    [_manager GET:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // 解密服务器返回值
        NSDictionary *result = [self sessionWithNetResponse:responseObject message:message];
        
        if ([result[@"result"] integerValue] == GYT_CODE_TOKEN_INVALID) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:result[@"info"] forKey:@"info"];
            [k_NotificationCenter postNotificationName:k_NOTIFICATION_TOKEN_INVALID object:self userInfo:userInfo];
        }
        
        if (success) {
            success(result); //成功回调
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        DLog(@"%@", task.taskDescription);
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)postRequestWithResquestMessage:(VHSRequestMessage *)message success:(RequestSuccess)success failure:(RequestFailure)failure {
    
    if (![VHSCommon isNetworkAvailable]) {
        if (success) {
            success(nil);
        }
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:message.params];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, message.path];
    DLog(@"URL %@", urlString);
    
    [_manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // 解密服务器返回值
        NSDictionary *result = [self sessionWithNetResponse:responseObject message:message];
        
        // 后端使token失效,强制重新登录
        if ([result[@"result"] integerValue] == GYT_CODE_TOKEN_INVALID) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:result[@"info"] forKey:@"info"];
            [k_NotificationCenter postNotificationName:k_NOTIFICATION_TOKEN_INVALID object:self userInfo:userInfo];
        }
        
        if (success) success(result); //成功回调
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (failure) failure(error);
    }];
}

// 流的形式上传头像
- (void)uploadRequestWithResquestMessage:(VHSRequestMessage *)message success:(RequestSuccess)success failure:(RequestFailure)failure {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, message.path];
    
    //2.上传文字时用到的拼接请求参数(如果只传图片，可不要此段）
    //NSMutableDictionary *params = [NSMutableDictionary dictionary];//创建一个名为params的可变字典
    //params[@"status"] = self.textView.text;//通过服务器给定的Key上传数据
    
    //3.发送请求
    [_manager POST:urlString parameters:message.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([message.imageArray count] > 1) {
            
            /*
             Data: 要上传的二进制数据
             name:保存在服务器上时用的Key值
             fileName:保存在服务器上时用的文件名,注意要加 .jpg或者.png
             mimeType:让服务器知道我上传的是哪种类型的文件
             */
            
            //多张图片
            for(NSInteger i = 0; i < [message.imageArray count]; i++)
            {
                // 取出图片
                UIImage *image = [message.imageArray objectAtIndex:i];
                // 转成二进制
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                // 上传的参数名
                NSString * name = [NSString stringWithFormat:@"pictureFile%ld", (long)i];
                // 上传fileName
                NSString * fileName = [NSString stringWithFormat:@"%@.jpg", name];
                
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            }
            
        } else {
            
            //单张图片
            UIImage *image = [message.imageArray firstObject];//获得一张Image
            NSData *data = UIImageJPEGRepresentation(image, 1.0);//将UIImage转为NSData，1.0表示不压缩图片质量。
            [formData appendPartWithFileData:data name:@"pictrueFile" fileName:@"pictrueFile.jpg" mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        // 解密服务器返回值
        NSDictionary *result = [self sessionWithNetResponse:response message:message];
        
        if (success) success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}

- (void)sendMessage:(VHSRequestMessage*)message success:(RequestSuccess)successBlock fail:(RequestFailure)failBlock {
    
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_NO_NETWORK];
        return;
    }
    
    _manager.requestSerializer.timeoutInterval = message.timeout ? message.timeout : CONNECT_TIMEOUT;
    
    // 设置http的头部
    [self setHttpHeaderFieldWithMessage:message];
    // 对数据包body，params加密
    [self encryptedMessage:message];
    
    // 正式版本
    if (message.httpMethod == VHSNetworkGET) {
        [self getRequestWithResquestMessage:message success:successBlock failure:failBlock];
    }
    else if (message.httpMethod == VHSNetworkPOST) {
        [self postRequestWithResquestMessage:message success:successBlock failure:failBlock];
    }
    else if (message.httpMethod == VHSNetworkUpload) {
        [self uploadRequestWithResquestMessage:message success:successBlock failure:failBlock];
    }
}

- (void)setHttpHeaderFieldWithMessage:(VHSRequestMessage *)message {
    if (![VHSCommon isNullString:[VHSCommon vhstoken]]) {
        [_manager.requestSerializer setValue:[VHSCommon vhstoken] forHTTPHeaderField:@"vhstoken"];
    } else {
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"vhstoken"];
    }
    
    CLog(@"vhstoken = %@", [VHSCommon vhstoken]);
    
    [_manager.requestSerializer setValue:[VHSCommon deviceToken] forHTTPHeaderField:@"imei"];
    [_manager.requestSerializer setValue:[VHSCommon osVersion] forHTTPHeaderField:@"osversion"];
    [_manager.requestSerializer setValue:[VHSCommon appVersion] forHTTPHeaderField:@"appversion"];
    [_manager.requestSerializer setValue:[VHSCommon phoneModel] forHTTPHeaderField:@"model"];
    
    if (message.httpMethod != VHSNetworkUpload) {
        [_manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"encrypt"];
    }
}

/// 加密传输给服务器的数据
- (void)encryptedMessage:(VHSRequestMessage *)message {
    NSString *aesKey = [VHSUtils generateRandomStr16];
    message.aesKey = aesKey;
    
    VHSSecurityUtil *security = [VHSSecurityUtil share];
    if (!message.params || ![[message.params allKeys] count]) {
        message.params = @{@"key" : [security rsaGenerateKeyOfRandomStr16WithKey:aesKey]};
    } else {
        message.params = [security encryptWithRandomKey:aesKey data:message.params sign:message.sign];
    }
}

/// 解密服务器返回的加密数据
- (NSDictionary *)sessionWithNetResponse:(NSDictionary *)netResponse message:(VHSRequestMessage *)message {
    // 解密服务器返回值
    NSString *sessionStream = netResponse[@"data"];
    NSString *response = [[VHSSecurityUtil share] aesDecryptStr:sessionStream pwd:message.aesKey];
    NSDictionary *result = [response convertObject];
    
    return result;
}

@end
