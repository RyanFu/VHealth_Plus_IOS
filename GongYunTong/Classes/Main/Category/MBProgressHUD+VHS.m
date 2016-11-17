//
//  MBProgressHUD+VHS.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "MBProgressHUD+VHS.h"

typedef NS_ENUM(NSInteger, HUDShowType)
{
    HUDShowJustLabelType,
    HUDShowWaitType
};
@implementation MBProgressHUD (VHS)

+ (UIWindow *)window {
    return [[[UIApplication sharedApplication] windows] lastObject];
}

+ (void)show {
    [self showMessage:nil];
}

+ (void)showDelay:(NSInteger)delay {
    [self show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenHUD];
    });
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message hideDelay:15 toView:nil showType:HUDShowWaitType];
}

+ (void)showSuccess:(NSString *)message {
    [self showMessage:message hideDelay:1.5 toView:nil showType:HUDShowJustLabelType];
}

+ (void)showError:(NSString *)message {
    [self showMessage:message hideDelay:1.5 toView:nil showType:HUDShowJustLabelType];
}

+ (void)hiddenHUD {
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view{
    
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    
    [self hideHUDForView:view animated:YES];
}


+ (void)showMessage:(NSString *)message hideDelay:(NSInteger)delay toView:(UIView *)view showType:(HUDShowType)type{
    
    if (!view) {
        view = [self window];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // default
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if (type == HUDShowWaitType) {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    else if (type == HUDShowJustLabelType) {
        hud.mode = MBProgressHUDModeText;
    }
    
    if (message == nil || message.length == 0) {
        hud.labelText = @"";
    } else {
        hud.labelText = message;
    }
    
    [hud hide:YES afterDelay:delay];
}

@end
