//
//  VHSActivityController.h
//  GongYunTong
//
//  Created by vhsben on 16/08/26.
//  Copyright © 2016年 average. All rights reserved.
//

#import "VHSBaseViewController.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface VHSActivityController : VHSBaseViewController<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@end
