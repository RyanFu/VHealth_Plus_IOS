//
//  MBProgressHUD+VHS.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "MBProgressHUD.h"
#import "MBProgressHUD+VHS.h"

@interface MBProgressHUD (VHS)

+ (void)showError:(NSString *)message;

+ (void)showSuccess:(NSString *)message;

+ (void)showMessage:(NSString *)message;

+ (void)hiddenHUD;

@end
