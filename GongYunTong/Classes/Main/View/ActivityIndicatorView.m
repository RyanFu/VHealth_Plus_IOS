//  ActivityIndicatorView.h
// MarkCheung
//
//  Created by Liang on 09/01/2014.
//  Copyright (c) 2014 sheng All rights reserved.
//

#import "ActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

        // 实现圆角效果
        view.layer.cornerRadius = 6;
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
        view.layer.masksToBounds = YES;
        view.center = self.center;
        frame = view.frame;
        frame.origin.y -= 50;
        view.frame = frame;
        
        // 风火轮的样式及位置
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.frame = CGRectMake(5, 5, 50, 50);
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.hidesWhenStopped = YES;
        [view addSubview:indicator];

        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 60, 20)];
        label.text = NSLocalizedString(@"LABEL_ACTIVITYINDICATOR_LOADING", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        [view addSubview:label];
        
        [self addSubview:view];

        [self stopAnimating];
    }
    return self;
}

- (id)initWithFrame2:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        // 实现圆角效果
        view.layer.cornerRadius = 6;
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
        view.layer.masksToBounds = YES;
        view.center = self.center;
        frame = view.frame;
        frame.origin.y -= 50;
        view.frame = frame;
        
        // 风火轮的样式及位置
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.frame = CGRectMake(25, 0, 50, 50);
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.hidesWhenStopped = YES;
        [view addSubview:indicator];
        
        // 加载标签
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 100, 20)];
        label.text = NSLocalizedString(@"LABEL_ACTIVITYINDICATOR_LOADING", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        [view addSubview:label];
            
        labelMore = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 100, 20)];
        labelMore.text = @"";
        labelMore.textAlignment = NSTextAlignmentCenter;
        labelMore.backgroundColor = [UIColor clearColor];
        labelMore.textColor = [UIColor whiteColor];
        labelMore.font = [UIFont boldSystemFontOfSize:10];
        [view addSubview:labelMore];
        
        [self addSubview:view];
        
        [self stopAnimating];
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    label.text = content;
}

-(void)setContentMore:(NSString *)content
{
    labelMore.text = content;
}

-(void)startAnimating{          // 开始等待
    self.hidden = NO;
    [indicator startAnimating];
}

-(void)stopAnimating{           // 结束等待
    self.hidden = YES;
    [indicator stopAnimating];  
}

@end
