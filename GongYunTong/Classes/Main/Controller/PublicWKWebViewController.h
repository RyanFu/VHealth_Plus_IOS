//
//  PublicWebViewController.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/29.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "VHSBaseViewController.h"

@interface PublicWKWebViewController : VHSBaseViewController<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) NSString *urlString;      // url地址
@property (nonatomic, assign) BOOL shouldToken;         // url连接token
@property (nonatomic, assign) BOOL showTitle;           // 显示title

@end
