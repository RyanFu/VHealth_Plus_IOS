//
//  VHSAdvertisiongControllerViewController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/4/14.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSAdvertisingController.h"

@interface VHSAdvertisingController ()

@property (assign, nonatomic) NSUInteger duration;
@property (strong, nonatomic) NSString *advertisingUrl;

@property (copy, nonatomic) void (^dismissBlock)();

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation VHSAdvertisingController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (instancetype)initWithAdUrl:(NSString *)adurl duration:(NSUInteger)seconds dismissCallBack:(void (^)())dismissBlock {
    self = [super init];
    
    if (self) {
        self.dismissBlock = dismissBlock;
        self.duration = seconds;
        self.advertisingUrl = adurl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    [self.view addSubview:self.imageView];
    self.imageView.image = [UIImage imageWithContentsOfFile:[VHSUtils getLocalImageWithPath:self.advertisingUrl]];
    
    [self performSelector:@selector(dismissCurrentVC) withObject:nil afterDelay:self.duration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissCurrentVC {
    [self.navigationController popViewControllerAnimated:NO];
    
    if (_dismissBlock) _dismissBlock();
}

@end
