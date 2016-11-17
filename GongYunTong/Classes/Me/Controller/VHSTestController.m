
//
//  VHSTestController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/9/12.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSTestController.h"
#import "VHSStepAlgorithm.h"
#import "VHSLocatServicer.h"
#import "PublicWKWebViewController.h"
#import "NSDate+VHSExtension.h"
#import "MBProgressHUD+VHS.h"

@interface VHSTestController ()

@property (nonatomic, strong) UITextField *beginF;
@property (nonatomic, strong) UITextField *endF;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation VHSTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 50)];
    confirmBtn.backgroundColor = [UIColor yellowColor];
    [confirmBtn setTitle:@"confirm" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    UITextField *f1 = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, 300, 50)];
    [f1 setBackgroundColor:[UIColor blueColor]];
    _beginF = f1;
    [self.view addSubview:f1];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 100, 50)];
    cancelBtn.backgroundColor = [UIColor yellowColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
}

- (void)confirmBtn:(UIButton *)btn {
//    [[VHSLocatServicer shareLocater] startUpdatingLocation]; // 开启定位服务
    
//    NSString *past = @"2016-11-01 10:54:00";
//    NSInteger pastday = [NSDate pastOfNowWithPastDateStr:past];
//    [VHSToast toast:[NSString stringWithFormat:@"%ld", (long)pastday]];
    
//    [VHSAlertController alertMessage:@"版本较低" title:@"升级提示" confirmHandler:^(UIAlertAction *action) {
//        
//    } cancleHandler:^(UIAlertAction *action) {
//        
//    }];
    
    [MBProgressHUD showDelay:2.0];
    NSLog(@"........");
}

- (void)cancelBtn:(UIButton *)btn {
//    [[VHSLocatServicer shareLocater] stopUpdatingLocation];
}

@end
