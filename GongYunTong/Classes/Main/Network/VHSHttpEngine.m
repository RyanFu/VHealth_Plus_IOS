//
//  VHSHttpEngine.m
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSHttpEngine.h"
#import "AFNetworking.h"
#import "SecurityUtil.h"

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

- (void)getRequest:(NSString *)urlPath parameters:(id)parameters success:(RequestSuccess)success failure:(RequestFailure)failure
{
    if (![VHSCommon isNetworkAvailable]) {
        if (success) {
            success(nil);
        }
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, urlPath];
    DLog(@"URL %@", urlString);
    [_manager GET:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = responseObject;
            if ([result[@"result"] integerValue] == GYT_CODE_TOKEN_INVALID) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:result[@"info"] forKey:@"info"];
                [k_NotificationCenter postNotificationName:k_NOTIFICATION_TOKEN_INVALID object:self userInfo:userInfo];
            }
        }
        // 解密服务器返回值
//        id response = [[SecurityUtil share] decryptBody:responseObject];
        if (success) {
            success(responseObject); //成功回调
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        DLog(@"%@", task.taskDescription);
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)postRequest:(NSString *)urlPath parameters:(id)parameters success:(RequestSuccess)success failure:(RequestFailure)failure
{
    if (![VHSCommon isNetworkAvailable]) {
        if (success) {
            success(nil);
        }
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, urlPath];
    DLog(@"URL %@", urlString);
    
    [_manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = responseObject;
            // 后端使token失效,强制重新登录
            if ([result[@"result"] integerValue] == GYT_CODE_TOKEN_INVALID) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:result[@"info"] forKey:@"info"];
                [k_NotificationCenter postNotificationName:k_NOTIFICATION_TOKEN_INVALID object:self userInfo:userInfo];
            }
        }
        // 解密服务器返回值
//        id response = [[SecurityUtil share] decryptBody:responseObject];
        if (success) {
            success(responseObject); //成功回调
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(error);
        }
    }];
}

// 流的形式上传头像
- (void)uploadUrl:(NSString *)urlPath file:(NSArray *)imageArray paramters:(NSDictionary *)params success:(RequestSuccess)success failure:(RequestFailure)failure {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, urlPath];
    
    //2.上传文字时用到的拼接请求参数(如果只传图片，可不要此段）
    //NSMutableDictionary *params = [NSMutableDictionary dictionary];//创建一个名为params的可变字典
    //params[@"status"] = self.textView.text;//通过服务器给定的Key上传数据
    
    //3.发送请求
    [_manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([imageArray count] > 1) {
            
            /*
             Data: 要上传的二进制数据
             name:保存在服务器上时用的Key值
             fileName:保存在服务器上时用的文件名,注意要加 .jpg或者.png
             mimeType:让服务器知道我上传的是哪种类型的文件
             */
            
            //多张图片
            for(NSInteger i = 0; i < [imageArray count]; i++)
            {
                // 取出图片
                UIImage *image = [imageArray objectAtIndex:i];
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
            UIImage *image = [imageArray firstObject];//获得一张Image
            NSData *data = UIImageJPEGRepresentation(image, 1.0);//将UIImage转为NSData，1.0表示不压缩图片质量。
            [formData appendPartWithFileData:data name:@"pictrueFile" fileName:@"pictrueFile.jpg" mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 解密服务器返回值
//        id response = [[SecurityUtil share] decryptBody:responseObject];
        if (success) success(responseObject);
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
    [self setHttpHeaderField];
    // 正式版本
    if (message.httpMethod == VHSNetworkGET) {
        [self getRequest:message.path parameters:message.params success:successBlock failure:failBlock];
    }
    else if (message.httpMethod == VHSNetworkPOST) {
        [self postRequest:message.path parameters:message.params success:successBlock failure:failBlock];
    }
    else if (message.httpMethod == VHSNetworkUpload) {
        [self uploadUrl:message.path file:message.imageArray paramters:message.params success:successBlock failure:failBlock];
    }
}

- (void)setHttpHeaderField {
    if (![VHSCommon isNullString:[VHSCommon vhstoken]]) {
        [_manager.requestSerializer setValue:[VHSCommon vhstoken] forHTTPHeaderField:@"vhstoken"];
    } else {
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"vhstoken"];
    }
    
    [_manager.requestSerializer setValue:[VHSCommon deviceToken] forHTTPHeaderField:@"imei"];
    [_manager.requestSerializer setValue:[VHSCommon osVersion] forHTTPHeaderField:@"osversion"];
    [_manager.requestSerializer setValue:[VHSCommon appVersion] forHTTPHeaderField:@"appversion"];
    [_manager.requestSerializer setValue:[VHSCommon phoneModel] forHTTPHeaderField:@"model"];
}



@end
