//
//  VHSForgetInfo.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/22.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSForgetInfo.h"

@implementation VHSForgetInfo


+(VHSForgetInfo *)infoWithTitle:(NSString *)title placeholder:(NSString *)paceholder
{
    VHSForgetInfo *info=[[VHSForgetInfo alloc]init];
    info.title=title;
    info.placeholder=paceholder;
    return info;
}

@end
