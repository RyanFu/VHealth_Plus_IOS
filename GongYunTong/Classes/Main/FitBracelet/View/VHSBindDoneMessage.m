//
//  VHSBindDoneMessage.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/29.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSBindDoneMessage.h"

@implementation VHSBindDoneMessage

+(instancetype)bindDoneMessageFromXib{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end
