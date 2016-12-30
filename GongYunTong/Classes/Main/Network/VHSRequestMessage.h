//
//  VHSRequestMessage.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

typedef NS_ENUM(NSInteger, VHSNetworkType) {
    VHSNetworkGET = 1,      // get
    VHSNetworkPOST,         // post
    VHSNetworkUpload        // 上传文件
};

#import <Foundation/Foundation.h>

@interface VHSRequestMessage : NSObject

@property (nonatomic, copy) NSString            *path;                     // 服务器路径
@property (nonatomic, assign) VHSNetworkType    httpMethod;                 // 提交服务器方式
@property (nonatomic, copy) NSArray             *imageArray;               // 上传图片集合
@property (nonatomic, assign) NSTimeInterval    timeout;                    // 请求服务器超时时间
@property (nonatomic, strong) NSDictionary      *params;                   // body参数

@property (nonatomic, strong) NSString          *sign;                      // 加密，关键参数签名
@property (nonatomic, strong) NSString          *aesKey;                    // 用于解密服务器返回已经加密的数据

@end
