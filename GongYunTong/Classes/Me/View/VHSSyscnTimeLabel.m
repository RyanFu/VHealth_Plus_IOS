//
//  VHSSyscnTimeLabel.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/30.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSSyscnTimeLabel.h"


@implementation VHSSyscnTimeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(NSString *)text
{
    NSString *new=[super text];
    if (new==nil) {
        CGRect rect= self.bounds;
        rect.size.height=0;
        self.bounds=rect;
    }
    return new;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
@end
