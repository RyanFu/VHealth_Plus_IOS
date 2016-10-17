//
//  UINavigationController+XLShouldPopExtention.m
//  CutNavBackTest2
//
//  Created by MacBook Pro on 16/3/23.
//  Copyright © 2016年 haoshenghuoLongXu. All rights reserved.
//

#import "UINavigationController+XLShouldPopExtention.h"
#import <objc/runtime.h>

@implementation UINavigationController (XLShouldPopExtention)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method original=class_getInstanceMethod(self, @selector(navigationBar:shouldPopItem:));
        Method swizzling=class_getInstanceMethod(self, @selector(xl_navigationBar:shouldPopItem:));
        BOOL didAddMethod=class_addMethod(self, @selector(navigationBar:shouldPopItem:), method_getImplementation(swizzling), method_getTypeEncoding(swizzling));
        if (didAddMethod) {
            class_replaceMethod(self, @selector(xl_navigationBar:shouldPopItem:), method_getImplementation(original), method_getTypeEncoding(original));
        } else {
        method_exchangeImplementations(original, swizzling);
        }
    });
    
}
-(BOOL)xl_navigationBar:(UINavigationBar *)bar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *topVC=self.topViewController;
    if (topVC.navigationItem!=item) {
        //自己写的pop方法
        return YES;
    }
    if ([topVC conformsToProtocol:@protocol(UINavigationControllerShouldPopProtocol)]) {
        if ([(id<UINavigationControllerShouldPopProtocol>)topVC navigationShouldPopOnBackButton:self]) {
            return [self xl_navigationBar:bar shouldPopItem:item];
        }else
        {
            //将返回按钮箭头透明度调整正常状态
            for(UIView *subview in [bar subviews]) {
                if(subview.alpha < 1.) {
                    [UIView animateWithDuration:.25 animations:^{
                        subview.alpha = 1.;
                    }];
                }
            }
            return NO;
        }
    }else
    {
        return [self xl_navigationBar:bar shouldPopItem:item];
    }
}
@end
