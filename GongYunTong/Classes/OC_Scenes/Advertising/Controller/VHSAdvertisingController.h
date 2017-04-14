//
//  VHSAdvertisiongControllerViewController.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/4/14.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHSAdvertisingController : UIViewController

- (instancetype)initWithAdUrl:(NSString *)adurl duration:(NSUInteger)seconds dismissCallBack:(void (^)())dismissBlock;

@end
