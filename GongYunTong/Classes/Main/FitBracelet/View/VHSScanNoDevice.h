//
//  VHSScanNoDevice.h
//  VHealth1.6
//
//  Created by vhsben on 16/6/29.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VHSScanNoDeviceDelegate <NSObject>

@optional

// 点击获取帮助代理方法 
-(void)scanNoDevice:(UIView *)scanNoDevice helpClick:(UIButton *)help;
//刷新
-(void)scanAgain:(UIView *)sacnNoDevice ;
@end

@interface VHSScanNoDevice : UIView

@property(nonatomic,weak)id<VHSScanNoDeviceDelegate>delegat;
+(instancetype)scanNoDeviceFromXib;
@end
