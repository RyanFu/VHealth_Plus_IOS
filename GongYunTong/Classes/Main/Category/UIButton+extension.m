//
//  UIButton+VHS_extension.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/29.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "UIButton+extension.h"

@implementation UIButton (extension)

- (void)countDownWithSeconds:(NSInteger)seconds {
    
    __block NSInteger timeout = seconds;
    
    UILabel *countdownLabel = [[UILabel alloc] initWithFrame:self.bounds];
    countdownLabel.backgroundColor = COLOR_TEXT_PLACEHOLDER;
    countdownLabel.textColor = [UIColor whiteColor];
    countdownLabel.textAlignment = NSTextAlignmentCenter;
    countdownLabel.layer.cornerRadius = 7;
    countdownLabel.layer.masksToBounds = YES;
    [self addSubview:countdownLabel];
    self.enabled = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.enabled = YES;
                [countdownLabel removeFromSuperview];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%ld秒",(long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                countdownLabel.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


@end
