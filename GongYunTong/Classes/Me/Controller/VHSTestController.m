
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

@interface VHSTestController ()

@property (nonatomic, strong) UIImageView *imageView2;

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
    
    NSString *imagePath = @"http://ste.india.com/sites/default/files/2016/01/21/452974-monkey.jpg";
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, SCREENW - 20, 100)];
    imageView1.backgroundColor = [UIColor purpleColor];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    [self.view addSubview:imageView1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 270, SCREENW - 20, 100)];
    _imageView2.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_imageView2];
}

- (void)confirmBtn:(UIButton *)btn {
    NSString *defaultPath = @"http://ste.india.com/sites/default/files/2016/01/21/452974-monkey.jpg";
    [VHSUtils saveImageWithPath:defaultPath];
    
    NSString *imageName = [[defaultPath componentsSeparatedByString:@"/"] lastObject];
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:imageName];
    
    CLog(@"%@", imagePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
        _imageView2.image = [UIImage imageWithData:data];
    }
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
