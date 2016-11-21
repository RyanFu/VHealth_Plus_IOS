//
//  UILabel+extension.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/30.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)

- (void)countDownWithSeconds:(NSInteger)durationTime {
    
    __block NSInteger timeout = durationTime;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.enabled = YES;
                [self removeFromSuperview];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%ld 秒",(long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (CGSize)sizeFit {
    CGRect frame = self.frame;
    NSString *text = self.text;
    
    CGRect fitRect = [text boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName : self.font}
                                         context:nil];
    
    CGSize fitSize = fitRect.size;
    
    if (frame.size.width < fitSize.width) {
        frame.size.width = fitSize.width;
    }
    if (frame.size.height < fitSize.height) {
        frame.size.height = fitSize.height;
    }
    
    self.frame = frame;
    
    return fitRect.size;
}

@end
