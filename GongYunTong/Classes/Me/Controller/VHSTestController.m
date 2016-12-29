
//
//  VHSTestController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/9/12.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSTestController.h"
#import "VHSStepAlgorithm.h"
#import "VHSLocatServicer.h"
#import "PublicWKWebViewController.h"
#import "NSDate+VHSExtension.h"
#import "MBProgressHUD+VHS.h"
#import "NSString+AES256.h"

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
    NSString *defaultPath = @"http://img.frbiz.com/pic/z70071b-300x300-1/dog.jpg";
    
    NSString *imagePath = [VHSUtils getLocalPathWithPath:defaultPath];
    
    CLog(@"%@", imagePath);
    
    if (![VHSCommon isNullString:imagePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
        _imageView2.image = [UIImage imageWithData:data];
    }
}

- (void)encryBtn:(UIButton *)btn {
    NSString *key = [VHSUtils md5:@"666666"];
    
    NSString *aes = [@"123456789" aes256_encrypt:key];
    NSString *deaes = [aes aes256_decrypt:key];
    
    CLog(@"%@---%@", aes, deaes);
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


@end
