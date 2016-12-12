//
//  XLAlertManager.m
//  GongYunTong
//
//  Created by vhsben on 16/7/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "XLAlertManager.h"
#import "XLAlertController.h"


static NSMutableArray <UIViewController *>*Vcs_;
@implementation XLAlertManager

+(void)initialize
{
    Vcs_=[NSMutableArray array];
   
}

+(void)alertWithMessage:(NSString *)message alertCancel:(NSString *)cancleTitle alertSure:(NSString *)sureTitle viewController:(UIViewController *)viewController alertViewControllerStyle:(XLAlertStyle)alertStyle done :(void(^)())doneClick
{
    XLAlertController *alertController=[XLAlertController alertControllerWithTitle:alertStyle==XLAlertStyleActionSheet ? nil :@"提示" message:message preferredStyle:alertStyle==XLAlertStyleActionSheet ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    if (cancleTitle) {
        UIAlertAction * cancel=[UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [Vcs_ removeLastObject];
        }];
        [alertController addAction:cancel];
    }
    if (sureTitle) {
        UIAlertAction * ok=[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (doneClick) {
                doneClick();
            }
           [Vcs_ removeLastObject];
        }];
        [alertController addAction:ok];
    }
    if (Vcs_.count>0) {
        if (Vcs_.count>1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[Vcs_ lastObject] presentViewController:alertController animated:YES completion:nil];
                [Vcs_ addObject:alertController];
            });
            return;
        }
        [[Vcs_ lastObject] presentViewController:alertController animated:YES completion:nil];
        [Vcs_ addObject:alertController];
        
    }else
    {
        [viewController presentViewController:alertController animated:YES completion:nil];
         [Vcs_ addObject:alertController];
        
    }
    
}
-(void)presentVC:(UIAlertController *)alertController
{
    [[Vcs_ lastObject] presentViewController:alertController animated:YES completion:nil];
    [Vcs_ addObject:alertController];
}
@end
