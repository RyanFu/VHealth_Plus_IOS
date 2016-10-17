//
//  XLAlertManager.h
//  GongYunTong
//
//  Created by vhsben on 16/7/26.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 弹出框类型*/
typedef NS_ENUM(NSInteger, XLAlertStyle) {
    XLAlertStyleAlert,   //普通警告框
    XLAlertStyleActionSheet
};
@interface XLAlertManager : NSObject

+(void)alertWithMessage:(NSString *)message alertCancel:(NSString *)cancleTitle alertSure:(NSString *)sureTitle viewController:(UIViewController *)viewController alertViewControllerStyle:(XLAlertStyle)alertStyle done :(void(^)())doneClick;
@end
