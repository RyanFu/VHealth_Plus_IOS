//
//  UIViewController+Tracking.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/17.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+Tracking.h"

@implementation UIViewController (Tracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(viewDidAppear:) withSEL:@selector(swizzled_viewDidAppear:)];
        [self swizzleSEL:@selector(viewDidDisappear:) withSEL:@selector(swizzled_viewDidDisappear:)];
    });
}

/// 交换两个方法的实现
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Method Swizzling

- (void)swizzled_viewDidAppear:(BOOL)animated {
    [self swizzled_viewDidAppear:animated];
    
    NSString *currentControllerTitle = [self getCurrentControllerTitle];
    if (!currentControllerTitle) return;
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:currentControllerTitle];
}

- (void)swizzled_viewDidDisappear:(BOOL)animated {
    [self swizzled_viewDidDisappear:animated];
    
    NSString *currentControllerTitle = [self getCurrentControllerTitle];
    if (!currentControllerTitle) return;
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:currentControllerTitle];
}

- (NSString *)getCurrentControllerTitle {
    if ([self isKindOfClass:[VHSNavigationController class]]) return nil;
    
    NSString *title = nil;
    if (self.title) {
        title = [self.title copy];
    }
    else if (self.tabBarItem.title) {
        title = [self.tabBarItem.title copy];
    }
    else if (self.navigationItem.title) {
        title = [self.navigationItem.title copy];
    }
    
    return title;
}

@end
