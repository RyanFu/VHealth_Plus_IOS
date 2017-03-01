
//
//  VHSTestController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/9/12.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "VHSTestController.h"
#import "VHSStepAlgorithm.h"
#import "VHSLocatServicer.h"
#import "PublicWKWebViewController.h"
#import "NSDate+VHSExtension.h"
#import "MBProgressHUD+VHS.h"

@interface VHSTestController ()

@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation VHSTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    confirmBtn.backgroundColor = [UIColor yellowColor];
    [confirmBtn setTitle:@"confirm" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    UIButton *encryBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, 100, 50)];
    encryBtn.backgroundColor = [UIColor yellowColor];
    [encryBtn setTitle:@"encryBtn" forState:UIControlStateNormal];
    [encryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [encryBtn addTarget:self action:@selector(encryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:encryBtn];
    
    NSString *imagePath = @"http://img.frbiz.com/pic/z70071b-300x300-1/dog.jpg";
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, SCREENW - 20, 100)];
    imageView1.backgroundColor = [UIColor purpleColor];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    [self.view addSubview:imageView1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 270, SCREENW - 20, 100)];
    _imageView2.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_imageView2];
    
    // 下载网络图片
    NSString *defaultPath = @"http://img.frbiz.com/pic/z70071b-300x300-1/dog.jpg";
    [VHSUtils saveImageWithPath:defaultPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(10, 380, self.view.frame.size.width - 20, 100)];
//    yellowView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:yellowView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 490, 300, 100)];
    textLabel.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:textLabel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)confirmBtn:(UIButton *)btn {
    
//    SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
//    [self presentViewController:sfvc animated:YES completion:nil];
    
//    NSString *defaultPath = @"http://img.frbiz.com/pic/z70071b-300x300-1/dog.jpg";
//    
//    NSString *imagePath = [VHSUtils getLocalPathWithPath:defaultPath];
//    
//    CLog(@"%@", imagePath);
//    
//    if (![VHSCommon isNullString:imagePath]) {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
//        _imageView2.image = [UIImage imageWithData:data];
//    }
//    
//    /// 开启定时任务
//    [[VHSStepAlgorithm shareAlgorithm] timedTask];
//    
//    __block NSInteger ex = 100;
//    CLog(@"定义block之前的值:%ld，地址 %p", ex, &ex);
//    
//    void (^testBlock)() = ^void(){
////        NSInteger ex = 150;
//        CLog(@"__block改变值之前的值:%ld，地址 %p", ex, &ex);
//        ex = 120;
//        CLog(@"__block调用之后的值:%ld, 地址 %p", ex, &ex);
//    };
//    CLog(@"block调用之前的值:%ld，地址 %p", ex, &ex);
//    
//    testBlock();
//    
//    
//    
//    NSMutableString *a = [NSMutableString stringWithFormat:@"aaaaa"];
//    CLog(@"block定义之前的值:%@，地址 %p", a, &a);
//    
//    void (^testStringBlock)() = ^void(){
//        CLog(@"block中改变值之前的值:%@，地址 %p", a, &a);
//        a.string = @"bbbbb";
////        a = [NSMutableString stringWithFormat:@"ccccc"];
//        CLog(@"block中改变值之后的值:%@，地址 %p", a, &a);
//    };
//    CLog(@"block定义之后的值:%@，地址 %p", a, &a);
//    
//    testStringBlock();

//    NSString *defaultPath = @"http://img.frbiz.com/pic/z70071b-300x300-1/dog.jpg";
//    
//    NSString *imagePath = [VHSUtils getLocalPathWithPath:defaultPath];
//    
//    CLog(@"%@", imagePath);
//    
//    if (![VHSCommon isNullString:imagePath]) {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
//        _imageView2.image = [UIImage imageWithData:data];
//    }
}

- (void)encryBtn:(UIButton *)btn {
}

- (void)playSandbox {
    // 获取Documents路径
    NSString *documentPath = NSHomeDirectory();
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    CLog(@"documentPath:\n%@", documentPath);
    CLog(@"documentPath:\n%@", docuPath);
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CLog(@"cachePath:\n%@", cachePath);
    
    NSString *prefrencePath = [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
    CLog(@"prefrencePath:\n%@", prefrencePath);
    
    NSString *tempPath = NSTemporaryDirectory();
    CLog(@"tempPath:\n%@", tempPath);
}

- (void)dealloc {
    CLog(@"%@ be dealloc", NSStringFromClass([self class]));
}


@end
