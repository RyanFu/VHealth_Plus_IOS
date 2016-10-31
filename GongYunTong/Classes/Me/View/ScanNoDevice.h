//
//  ScanNoDevice.h
//  GongYunTong
//
//  Created by pingjun lin on 16/10/31.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanNoDevice : UIView

@property (nonatomic, copy) void(^getHelpBlock)();

+ (ScanNoDevice *)scanNoDeviceFromNib;

@end
