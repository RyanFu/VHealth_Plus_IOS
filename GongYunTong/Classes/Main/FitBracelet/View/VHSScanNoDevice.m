//
//  VHSScanNoDevice.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/29.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSScanNoDevice.h"


@interface VHSScanNoDevice ()

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crayWidthSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crayHeightSpace;
@end
@implementation VHSScanNoDevice

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer)];
    [self.tapView addGestureRecognizer:tap];
    if (iphone4x_3_5) {
        self.crayWidthSpace.constant=self.crayHeightSpace.constant=65.0f;
    }else
    {
        self.crayWidthSpace.constant=self.crayHeightSpace.constant=85.0f;
    }
}
+(instancetype)scanNoDeviceFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
//点击获取帮助
- (IBAction)helpClick:(UIButton *)sender {
    
    if (self.delegat &&[self.delegat respondsToSelector:@selector(scanNoDevice:helpClick:)]) {
        [self.delegat scanNoDevice:self helpClick:sender];
    }
}
-(void)tapRecognizer
{
    if (self.delegat &&[self.delegat respondsToSelector:@selector(scanAgain:)]) {
        [self.delegat scanAgain:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
