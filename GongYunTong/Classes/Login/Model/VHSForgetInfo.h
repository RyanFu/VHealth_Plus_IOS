//
//  VHSForgetInfo.h
//  GongYunTong
//
//  Created by ios-bert on 16/7/22.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSForgetInfo : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,copy)NSString *detailInfo;
+(VHSForgetInfo *)infoWithTitle:(NSString *)title placeholder:(NSString *)paceholder;
@end
