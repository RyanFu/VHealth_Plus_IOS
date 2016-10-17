
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


@interface VHSTestController ()

@property (nonatomic, strong) UITextField *beginF;
@property (nonatomic, strong) UITextField *endF;

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
    
//    UITextField *f2 = [[UITextField alloc] initWithFrame:CGRectMake(50, 300, 300, 50)];
//    [f2 setBackgroundColor:[UIColor blueColor]];
//    _endF = f2;
//    [self.view addSubview:f2];
}


- (void)confirmBtn:(UIButton *)btn {
    
    [[VHSLocatServicer shareLocater] startUpdatingLocation]; // 开启定位服务
    
//    NSString *start = [NSString stringWithFormat:@"%@ 00:00:01", _beginF.text];
//    NSString *end = [NSString stringWithFormat:@"%@ 23:59:59", _beginF.text];
//    
//    VHSStepAlgorithm *algo = [VHSStepAlgorithm shareAlgorithm];
//    [algo stepsFromMobileWithBeginTime:start endTime:end stepsBlock:^(NSInteger numberOfSteps) {
//        NSLog(@"numbersOfSteps = %ld", (long)numberOfSteps);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"steps" message:[NSString stringWithFormat:@"%ld", numberOfSteps] delegate:nil cancelButtonTitle:@"cancle" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
}

- (void)cancelBtn:(UIButton *)btn {
    [[VHSLocatServicer shareLocater] stopUpdatingLocation];
}

@end
